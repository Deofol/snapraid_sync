#!/bin/bash

# Function to stop Docker container and wait until stopped
stop_container() {
    echo "Stopping Docker container..."
    docker stop nextcloud
    while [ "$(docker inspect -f '{{.State.Status}}' nextcloud)" == "running" ]; do
        sleep 1
    done
    echo "Docker container stopped."
}

# Function to start Docker container
start_container() {
    echo "Starting Docker container..."
    docker start nextcloud
    echo "Docker container started."
}

# Stop Docker container
stop_container

# Run SnapRAID sync
echo "Running SnapRAID sync..."
snapraid sync

# Wait until SnapRAID sync completes
echo "Waiting for SnapRAID sync to complete..."
snapraid status -q
while [ $? -ne 0 ]; do
    sleep 10
    snapraid status -q
done
echo "SnapRAID sync completed."

# Start Docker container
start_container

echo "Script execution complete."
