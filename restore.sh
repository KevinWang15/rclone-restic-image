#!/bin/bash
set -e

mkdir -p /root/.config/rclone/

# Decode and create rclone config
echo "$RCLONE_CONFIG_BASE64" | base64 -d > /root/.config/rclone/rclone.conf

# Start rclone serve restic in the background
rclone serve restic "$RCLONE_BACKUP_PATH" --addr :8080 &

# Function to check if the port is ready
wait_for_port() {
    local port="$1"
    local timeout="${2:-60}"  # Default timeout of 60 seconds
    local start_time=$(date +%s)

    while ! nc -z localhost "$port"; do
        if [ $(($(date +%s) - start_time)) -ge "$timeout" ]; then
            echo "Timed out waiting for port $port"
            return 1
        fi
        sleep 1
    done
    return 0
}

# Wait for rclone to start serving on port 8080
if wait_for_port 8080; then
    echo "rclone is now serving on port 8080"
else
    echo "Failed to start rclone server. Exiting."
    exit 1
fi

# Run restic restore
restic -r rest:http://localhost:8080 restore latest --target /restore

# Keep the container running
tail -f /dev/null
