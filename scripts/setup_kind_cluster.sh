#!/bin/bash

# Check system architecture
ARCH=$(uname -m)

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

# Install kind depending on the system architecture
if [ $ARCH = "x86_64" ]; then
    KIND_URL="https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64"
elif [ $ARCH = "aarch64" ]; then
    KIND_URL="https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-arm64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

echo "Downloading kind binary for $ARCH..."
curl -Lo ./kind $KIND_URL
chmod +x ./kind

# Move kind binary to /usr/local/bin
sudo mv ./kind /usr/local/bin/kind

echo "kind has been installed."

# Create a Kind cluster named "ignite-dev"
kind create cluster --name ignite-dev

# Download kubeconfig for the cluster
mkdir -p ~/.kube
kind get kubeconfig --name ignite-dev > ~/.kube/config_kind
