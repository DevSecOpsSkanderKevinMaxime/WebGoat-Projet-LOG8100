# Installation guide and setup to run our kubernetes cluster

## Prerequisities

### 1. Download [docker-desktop](https://www.docker.com/products/docker-desktop/)

### 2. Install [minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Fmacos%2Farm64%2Fstable%2Fbinary+download)

**on macos run:** `brew install minikube`

**on linux run:** `sudo snap install minikube --classic`

### 3. Install [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

**on macos run:** `brew install terraform`

**on linux run:** `sudo apt install -y terraform`

## Cluster deployment

### Make sure the ./terraform/setup_minikube.sh is set to be executable

you can do so by typing `chmod +x ./terraform/setup_minikube.sh` in the terminal

### Execute the minikube setup sctipt by running `./terraform/setup_minikube.sh` in the terminal

### 1. Run `terraform init` in ./terraform

### 2. Run `terraform plan`

### 3. Run `terraform apply`

