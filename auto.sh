#!/bin/bash
# Configuration
NODE1_IP="192.168.0.67"
NODE1_USER="anna"
NODE1_PASS="ZenTOOL0317_!"
MAX_RETRIES=10
RETRY_DELAY=5

# Function to log messages with timestamp
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Function to execute the remote command
execute_remote_command() {
    log "Connecting to Node1 ($NODE1_IP)..."
    
    # Create a temporary script file that will be executed on the remote server
    # This script handles the sudo password and runs the autoexec.sh
    TMP_SCRIPT=$(mktemp)
    cat > $TMP_SCRIPT << 'EOF'
#!/bin/bash
cd zentool
PASSWORD="ZenTOOL0317_!"
echo "$PASSWORD" | sudo -S bash autoexec.sh 2>&1
EOF
    
    # Use sshpass to handle SSH authentication and execute the temporary script
    sshpass -p "$NODE1_PASS" scp -o StrictHostKeyChecking=no $TMP_SCRIPT $NODE1_USER@$NODE1_IP:/tmp/remote_exec.sh
    sshpass -p "$NODE1_PASS" ssh -o StrictHostKeyChecking=no \
                                 -o ConnectTimeout=10 \
                                 $NODE1_USER@$NODE1_IP "chmod +x /tmp/remote_exec.sh && /tmp/remote_exec.sh && rm /tmp/remote_exec.sh"
    
    # Capture the exit code
    local exit_code=$?
    
    # Remove the temporary script
    rm -f $TMP_SCRIPT
    
    # Check if connection was closed unexpectedly
    if [ $exit_code -ne 0 ]; then
        log "Connection failed or was closed unexpectedly (exit code: $exit_code)"
        return 1
    fi
    
    log "Command executed successfully on Node1."
    return 0
}

# Main script execution
main() {
    log "Starting Node1 automation script"
    
    # Check if sshpass is installed
    if ! command -v sshpass &> /dev/null; then
        log "Error: 'sshpass' is not installed. Please install it with 'sudo apt-get install sshpass'"
        exit 1
    fi
    
    # Initialize retry counter
    retry_count=0
    
    # Loop to handle reconnections
    while true; do
        # Attempt to execute the remote command
        if execute_remote_command; then
            # If successful, reset retry counter
            retry_count=0
            # Sleep for a while before the next check (optional)
            sleep 60
        else
            # Increment retry counter
            ((retry_count++))
            
            # Check if we've exceeded the maximum retries
            if [ $retry_count -gt $MAX_RETRIES ]; then
                log "Exceeded maximum retry attempts ($MAX_RETRIES). Exiting..."
                exit 1
            fi
            
            # Wait before retrying
            log "Retrying in $RETRY_DELAY seconds... (Attempt $retry_count of $MAX_RETRIES)"
            sleep $RETRY_DELAY
        fi
    done
}

# Start the script
main
