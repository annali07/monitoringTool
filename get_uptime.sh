#!/bin/bash
source "/home/csci699/monitor/config.env"
uptime_output=$(ssh -o BatchMode=yes -o ConnectTimeout=3 192.168.0.67 "uptime" 2>/dev/null)
if [ $? -eq 0 ]; then
    echo "[2025-03-24 09:36:15] ⏱️  Uptime: $uptime_output"
else
    echo "[2025-03-24 09:36:15] ⏱️  Uptime: Unable to retrieve"
fi
