#!/bin/env bash

proxy-on() {
  local HOST=127.0.0.1
  export {http,https}_proxy=$HOST:10809
  export all_proxy=$HOST:10809

  echo "on" > ~/.cache/proxy_state
}

proxy-off() {
  unset {all,http,https}_proxy
  echo "off" > ~/.cache/proxy_state
}

proxy-toggle() {
  if [[ -z "$all_proxy" ]]; then
    proxy-on && echo "proxy on: $all_proxy"
  else
    proxy-off && echo "Proxy off"
  fi
}

proxy-state() {
  if [[ -z "$all_proxy" ]]; then
    echo -n ""
  else
    echo -n "1"
  fi
}

wtf-ip() {
    curl -s https://wtfismyip.com/json | jq
}

if [[ -f ~/.cache/proxy_state && `cat ~/.cache/proxy_state` == 'on' ]]; then
    proxy-on
fi

