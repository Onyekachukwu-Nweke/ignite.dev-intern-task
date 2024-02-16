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

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo "kubectl is not installed. Installing..."
    
    # Download the latest version of kubectl
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
    
    # Make kubectl executable
    chmod +x ./kubectl
    
    # Move kubectl to a directory in your PATH (you may need sudo for this)
    sudo mv ./kubectl /usr/local/bin/kubectl
    
    echo "kubectl installed successfully."
else
    echo "kubectl is already installed."
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

# Create a Kind cluster named "ignite-dev and enable ingress"
cat <<EOF | kind create cluster --name ignite-dev --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
- role: worker
- role: worker
EOF

# Download kubeconfig for the cluster
mkdir -p ~/.kube
kind get kubeconfig --name ignite-dev > ~/.kube/config_kind

# Switch Kind context
kubectl config use-context kind-ignite-dev

kubectl cluster-info --context kind-ignite-dev


# Install NGINX ingress in KIND ignite-dev cluster
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml