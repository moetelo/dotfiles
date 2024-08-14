#!/bin/bash

set -eo pipefail

XRAY_CONFIG_PATH="/etc/xray/client7.json"

xray_ip=$(jq -r '.outbounds[0].settings.vnext[0].address' < $XRAY_CONFIG_PATH)
socks_inbound=$(jq -r '.inbounds[]|select(.protocol =="socks")|"\(.listen):\(.port)"' < $XRAY_CONFIG_PATH)

def_gate=$(ip route show default | awk '{print$3}')

trap_ctrlc() {
    echo 'trapped ctrl-c, cleaning up...'
    ip tuntap del dev tun0 mode tun
    ip route del $xray_ip via $def_gate
}

trap trap_ctrlc EXIT

ip tuntap add dev tun0 mode tun user $(whoami)
ip addr add 10.0.0.1/24 dev tun0
ip addr add fdfe:dcba:9876::1/125 dev tun0
ip route add $xray_ip via $def_gate
ip link set tun0 up
ip -6 link set tun0 up
ip route add default dev tun0
ip -6 route add default dev tun0

xray -c $XRAY_CONFIG_PATH > /dev/null &

tun2socks -device tun://tun0 -proxy socks5://$socks_inbound
