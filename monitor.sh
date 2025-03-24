#!/bin/bash

# Simple script to continuously check if node1 is up or down
# All files contained in /home/csci699/monitor

# Create directory if it doesn't exist
SCRIPT_DIR="/home/csci699/monitor"
mkdir -p $SCRIPT_DIR

# Configuration
NODE1_IP="192.168.0.67"
LOG_FILE="$SCRIPT_DIR/node1_status.log"
CHECK_INTERVAL=1  # Seconds between checks

# Clear screen once
clear

# Print header (only once)
echo "==============================================="
echo "            NODE1 STATUS MONITOR"
echo "==============================================="
echo
echo "Monitoring node1 ($NODE1_IP) status..."
echo "Press Ctrl+C to exit"
echo

# Continuous monitoring loop
while true; do
    # Check node status
    if ping -c 1 -W 1 $NODE1_IP > /dev/null 2>&1; then
        status="[$(date '+%Y-%m-%d %H:%M:%S')] Node1 is UP"
    else
        status="[$(date '+%Y-%m-%d %H:%M:%S')] Node1 is DOWN"
    fi
    
    # Display and log the status (without clearing screen)
    echo "$status"
    echo "$status" >> $LOG_FILE
    
    # Wait before next check
    sleep $CHECK_INTERVAL
done
