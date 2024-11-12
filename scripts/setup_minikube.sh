#!/bin/bash

# Set configuration values
MINIKUBE_CPUS="${MINIKUBE_CPUS:-4}"          # Default CPU count
MINIKUBE_MEMORY="${MINIKUBE_MEMORY:-16384}"    # Default memory in MB
MINIKUBE_DRIVER="${MINIKUBE_DRIVER:-docker}"  # Default driver
ENABLE_GPU="${ENABLE_GPU:-true}"             # Set to "true" to enable GPU

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}


if ! command_exists minikube; then
    echo "Minikube is not installed. Please install it before running this script."
    exit 1
fi


if ! command_exists kubectl; then
    echo "kubectl is not installed. Please install it before running this script."
    exit 1
fi


if [[ "$MINIKUBE_DRIVER" == "docker" ]] && ! command_exists docker; then
    echo "Docker is not installed. Please install it before running this script."
    exit 1
fi

# Start Minikube with specified resources and GPU support if enabled
echo "Starting Minikube with Docker driver, $MINIKUBE_CPUS CPUs, $MINIKUBE_MEMORY MB memory..."

# Check if GPU is requested and available
if [[ "$ENABLE_GPU" == "true" ]]; then
    echo "Enabling GPU support in Minikube..."
    minikube start --driver=$MINIKUBE_DRIVER --cpus=$MINIKUBE_CPUS --memory=$MINIKUBE_MEMORY --gpu
else
    minikube start --driver=$MINIKUBE_DRIVER --cpus=$MINIKUBE_CPUS --memory=$MINIKUBE_MEMORY
fi

# Check if Minikube started successfully
if [ $? -ne 0 ]; then
    echo "Minikube failed to start. Exiting..."
    exit 1
fi

# Ensure Minikube is running
if ! minikube status | grep -q "host: Running"; then
    echo "Minikube is not running. Exiting..."
    exit 1
fi

# Step 3: (Optional) Configure Docker environment to use Minikube's Docker daemon
echo "Configuring Docker to use Minikube's Docker daemon..."
eval $(minikube -p minikube docker-env)

# Step 4: Verify setup
echo "Minikube setup completed successfully."
echo "You can now build Docker images locally for Minikube or proceed to run Nextflow workflows."

# Optional reminder message
echo "To revert Docker to your local environment, use 'eval \$(minikube -p minikube docker-env --unset)'"
