#!/bin/bash

set -eo pipefail

XRAY_CONFIG_PATH=$1
if [ -z "$XRAY_CONFIG_PATH" ]; then
    echo "Usage: $0 <path to xray config>"
    exit 1
fi

# Fix inbounds that conflict with the service
tunnel_xray_config=$(jq '
  .inbounds |= map(select(.protocol == "socks")) |
  .inbounds[0].port = 10008
' "$XRAY_CONFIG_PATH")

xray_ip=$(jq -r '.outbounds[0].settings.vnext[0].address' <<< "$tunnel_xray_config")
socks_inbound=$(jq -r '.inbounds[]|select(.protocol =="socks")|"\(.listen):\(.port)"' <<< "$tunnel_xray_config")

default_ip=$(ip route show default | head -1 | awk '{print $3}')
default_iface=$(ip route show default | head -1 | awk '{print $5}')

recreate_default_with_metric_10() {
    ip route del default
    ip route add default via "$default_ip" dev "$default_iface" metric 10
}

cleanup() {
    echo 'Cleanup...'
    ip tuntap del dev tun0 mode tun
    ip route del "$xray_ip" via "$default_ip"
    recreate_default_with_metric_10
}

trap cleanup SIGINT SIGTERM EXIT

recreate_default_with_metric_10

ip tuntap add dev tun0 mode tun user "$(whoami)"
ip addr add 10.0.0.1/24 dev tun0
ip route add "$xray_ip" via "$default_ip" metric 1
ip link set tun0 up
ip -6 link set tun0 up
ip route add default dev tun0
ip -6 route add default dev tun0

xray <<< "$tunnel_xray_config" > /dev/null &

tun2socks -device tun://tun0 -proxy "socks5://$socks_inbound"
