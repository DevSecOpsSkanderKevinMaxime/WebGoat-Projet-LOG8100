# Installation guide and setup to run our kubernetes cluster

## Prerequisities

### 1. Download docker desktop following this link: https://www.docker.com/products/docker-desktop/

### 2. Install minikube

**on macos run:** `brew install minikube`

**on linux run:** `sudo snap install minikube --classic`

### 3. Install terraform

**on macos run:** `brew install terraform`

**on linux run:** `sudo apt install -y terraform`

## Cluster deployment

### Make sure the ./terraform/setup_minikube.sh is set to be executable

you can do so by typing `chmod +x ./terraform/setup_minikube.sh` in the terminal

### Execute the minikube setup sctipt by running `./terraform/setup_minikube.sh` in the terminal
