#!/bin/bash
source "/home/csci699/monitor/config.env"
if timeout 3 ssh -o BatchMode=yes -o ConnectTimeout=3 192.168.0.67 "echo 2>/dev/null" > /dev/null 2>&1; then
    echo "[2025-03-24 09:36:15] 🟢 SSH on Node1 is RESPONSIVE"
    exit 0
else
    echo "[2025-03-24 09:36:15] 🔴 SSH on Node1 is NOT RESPONSIVE"
    exit 1
fi
