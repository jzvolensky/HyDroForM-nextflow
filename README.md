# HyDroForM Nextflow

[![Nextflow](https://img.shields.io/badge/Nextflow-24.10.0.5928-brightgreen)](https://www.nextflow.io/)
[![Docker](https://img.shields.io/badge/Docker-27.3.1-brightgreen)](https://www.docker.com/)
[![Minikube](https://img.shields.io/badge/Minikube-1.34.0-brightgreen)](https://minikube.sigs.k8s.io/docs/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes--brightgreen)](https://kubernetes.io/)
[![Python](https://img.shields.io/badge/Python-3.10.12-brightgreen)](https://www.python.org/)
[![Java](https://img.shields.io/badge/Java-17-brightgreen)](https://www.java.com/)

This repository aims to translate our existing HyDroForM CWL workflows to Nextflow.

## Table of Contents

- [HyDroForM Nextflow](#hydroform-nextflow)
  - [Table of Contents](#table-of-contents)
  - [Experimental Architecture (TODO)](#experimental-architecture)
  - [Installation of the Environment](#installation-of-the-environment)
    - [Hardware Setup](#hardware-setup)
    - [Software Setup](#software-setup)
      - [Install Docker Engine](#install-docker-engine)
      - [Nvidia Container Toolkit](#nvidia-container-toolkit)
      - [Install Minikube](#install-minikube)
      - [Install Nextflow](#install-nextflow)
      - [Setting up Minikube (TODO)](#setting-up-minikube)
      - [Automated Installation](#automated-installation)
      - [Coupling Minikube cluster with Nextflow](#coupling-minikube-cluster-with-nextflow)
    - [Running a sample workflow](#running-a-sample-workflow)
    - [Running a workflow in Minikube (TODO)](#running-a-workflow-in-minikube)

## Experimental Architecture

TODO: Add a diagram of the architecture

## Installation of the Environment

### Hardware Setup

Our reference testing Virtual Machine:

- Ubuntu 22.04.5 LTS
- 8 CPUs,
- 32 GB RAM
- Nvidia A100 GPU

Without a GPU you can run this setup and simple workflows on Minikube with little resources.

Tested on Digital Ocean Droplet with:

- Ubuntu 22.04.5 LTS
- 2 CPUs,
- 4 GB RAM
- No GPU

### Software Setup

This section describes step by step how to install all of the required software on a blank VM.

#### Install Docker Engine

See the docs for more details: [Docker](https://docs.docker.com/engine/install/ubuntu/)

Setting up the repository:

```zsh
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

 sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Or using an automated install of Docker Engine:

```zsh
curl -fsSL https://get.docker.com | sh
```

Following the Linux post-installation steps:

```zsh
sudo usermod -aG docker ${USER}
```

Log out and log back in so that your group membership is re-evaluated.

Or
  
```zsh
newgrp docker
```

Test the installation with:

```zsh
docker run hello-world
```

#### Nvidia Container Toolkit

If you are planning to use GPUs and run Docker containers, you will need to install the Nvidia Container Toolkit:

[Nvidia Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

```zsh
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
```

```zsh
sudo apt-get update
```

```zsh
sudo apt-get install -y nvidia-container-toolkit
```

#### Install Minikube

Start by installing kubectl:

```zsh
mkdir -p $HOME/.local/bin \
&& curl -fsSLo $HOME/.local/bin/kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
&& chmod +x $HOME/.local/bin/kubectl
```

Then install Minikube:

```zsh
mkdir -p $HOME/.local/bin \
&& curl -fsSLo $HOME/.local/bin/minikube "https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64" \
&& chmod +x $HOME/.local/bin/minikube
```

#### Install Nextflow

Nextflow requires `Bash 3.2` or later as well as `Java 17 up to 23`

The suggested way to install Java is to use `SDKMAN`:

```zsh
curl -s "https://get.sdkman.io" | bash
```
  
  Then install Java:
  
  ```zsh
  sdk install java 17.0.10-tem
  ```

Nextflow can be installed with the following command:

```zsh
curl -s https://get.nextflow.io | bash
chmod +x nextflow # make it executable
mkdir -p $HOME/.local/bin/ # create the bin directory
mv nextflow $HOME/.local/bin/ # move the executable to the bin directory
```

Make sure to include the directory in your PATH:

```zsh
echo 'export PATH=$HOME/.local/bin:$PATH' >> $HOME/.bashrc
source $HOME/.bashrc
```

or for `zsh` afficionados:

```zsh
echo 'export PATH=$HOME/.local/bin:$PATH' >> $HOME/.zshrc
source $HOME/.zshrc
```

#### Setting up Minikube

TODO: Add instructions on how to set up Minikube

### Automated Installation

You can use the provided script to automate the installation process:

```zsh
sudo ./scripts/install.sh
```

It basically runs all of the commands mentioned above in the correct order.

Then you can use `setup_minikube.sh` to set up Minikube with the correct configuration.

```zsh
./scripts/setup_minikube.sh
```

#### Coupling Minikube cluster with Nextflow

In the `nextflow.config` file make sure you set the namespace, serviceAccount and context based on your deployment.

Enabling `fusion` removes the need for creating a PVC (Persistent Volume Claim)

#### Running a sample workflow

To run a sample workflow locally, you can use the following command:

```zsh
cd src
nextflow run test-workflow.nf
```

#### Running a workflow in Minikube

TODO
