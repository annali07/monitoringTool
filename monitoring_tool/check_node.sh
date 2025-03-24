#!/bin/bash
source "/home/csci699/monitor/config.env"
if ping -c 1 -W 1 192.168.0.67 > /dev/null 2>&1; then
    echo "[2025-03-24 09:36:15] 🟢 Node1 is UP"
    exit 0
else
    echo "[2025-03-24 09:36:15] 🔴 Node1 is DOWN"
    exit 1
fi
