#!/bin/bash
source "/home/csci699/monitor/config.env"
reboot_status=$(ssh -o BatchMode=yes -o ConnectTimeout=3 192.168.0.67 "who -b" 2>/dev/null)
if [ $? -eq 0 ]; then
    echo "[2025-03-24 09:36:15] 🔄 Last boot: $reboot_status"
fi
