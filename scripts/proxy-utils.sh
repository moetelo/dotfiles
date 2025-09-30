#!/bin/env bash

wtf-ip() {
    curl -s https://wtfismyip.com/json | jq
}
