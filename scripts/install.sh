#!/bin/bash

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Update and install prerequisites
sudo apt-get update
sudo apt-get install -y ca-certificates curl

# Install Docker Engine
if ! command_exists docker; then
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  curl -fsSL https://get.docker.com | sh
  sudo usermod -aG docker ${USER}
else
  echo "Docker is already installed"
fi

# Install Nvidia Container Toolkit
if ! dpkg-query -W nvidia-container-toolkit; then
  curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
  curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
  sudo apt-get update
  sudo apt-get install -y nvidia-container-toolkit
else
  echo "Nvidia Container Toolkit is already installed"
fi

# Install kubectl
if ! command_exists kubectl; then
  mkdir -p $HOME/.local/bin
  curl -fsSLo $HOME/.local/bin/kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  chmod +x $HOME/.local/bin/kubectl
else
  echo "kubectl is already installed"
fi

# Install Minikube
if ! command_exists minikube; then
  curl -fsSLo $HOME/.local/bin/minikube "https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64"
  chmod +x $HOME/.local/bin/minikube
else
  echo "Minikube is already installed"
fi

# Install SDKMAN and Java
if ! command_exists sdk; then
  if ! command_exists unzip; then
    echo "unzip is required for SDKMAN installation. Installing unzip..."
    sudo apt-get install -y unzip
  fi
  curl -s "https://get.sdkman.io" | bash
  source "$HOME/.sdkman/bin/sdkman-init.sh"
  sdk install java 17.0.10-tem
else
  echo "SDKMAN is already installed"
fi

# Install Nextflow
if ! command_exists nextflow; then
  curl -s https://get.nextflow.io | bash
  chmod +x nextflow
  mkdir -p $HOME/.local/bin/
  mv nextflow $HOME/.local/bin/
else
  echo "Nextflow is already installed"
fi

# Update PATH
if [ -n "$ZSH_VERSION" ]; then
  echo 'export PATH=$HOME/.local/bin:$PATH' >> $HOME/.zshrc
  source $HOME/.zshrc
else
  echo 'export PATH=$HOME/.local/bin:$PATH' >> $HOME/.bashrc
  source $HOME/.bashrc
fi

echo "Installation complete. Please log out and log back in to apply Docker group changes."