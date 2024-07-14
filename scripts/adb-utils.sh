#!/bin/env bash

adb-get-ip() {
    adb shell "ip addr show wlan0 | grep -e wlan0$ | cut -d\" \" -f 6 | cut -d/ -f 1"
}

adb-connect() {
    IP=$(adb-get-ip)
    echo $IP
    PORT=$(nmap $IP -p 37000-44000 | awk "/\/tcp/" | cut -d/ -f1)
    adb connect $IP:$PORT
}
