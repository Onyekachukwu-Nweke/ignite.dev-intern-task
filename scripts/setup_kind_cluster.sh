#!/bin/bash

# Check if docker is installed on the system if it isn't then install it
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Installing Docker..."
    
    # Install Docker
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    
    # Add current user to the docker group to run docker commands without sudo
    sudo usermod -aG docker $USER
    
    # Activate the changes to groups
    newgrp docker
    
    echo "Docker has been installed."
else
    echo "Docker is already installed."
fi


# # Install kind depending on the system architecture
# curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
# chmod +x ./kind
# mv ./kind /usr/local/bin/kind
