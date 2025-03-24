#!/bin/bash

# Load variables from parent script
source "$SCRIPT_DIR/config.env"

echo "Node1 Status Monitor - Started at $(date)";
echo "----------------------------------------------";
echo "";

while true; do
    clear;
    echo "=============================================";
    echo "         NODE1 STATUS MONITOR";
    echo "=============================================";
    echo "";
    
    # Check ping status
    if $SCRIPT_DIR/check_node.sh; then
        $SCRIPT_DIR/check_ssh.sh;
        if [ $? -eq 0 ]; then
            $SCRIPT_DIR/get_uptime.sh;
            $SCRIPT_DIR/check_reboot.sh;
        fi
    fi
    
    echo "";
    echo "=============================================";
    echo "Last updated: $(date)";
    echo "Monitoring from: $(hostname)";
    echo "Log file: $LOG_FILE";
    echo "Press Ctrl+C to exit";
    
    # Log status to file
    $SCRIPT_DIR/check_node.sh >> $LOG_FILE;
    
    # Wait before next check
    sleep $CHECK_INTERVAL;
done
