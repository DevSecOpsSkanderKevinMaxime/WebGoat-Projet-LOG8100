#!/bin/bash

# Démarrer Minikube avec 2 nœuds
echo "Starting Minikube with 2 nodes..."
minikube start --nodes 2 -p multi-node-cluster

# Vérifier que les nœuds sont en cours d'exécution
echo "Checking nodes in the cluster..."
kubectl get nodes

# Déployer l'application avec mydeployment.yaml
echo "Applying deployment from mydeployment.yaml..."
kubectl apply -f mydeployment.yaml

# Vérifier le déploiement et afficher les pods déployés
echo "Getting deployment details..."
kubectl get deployments
echo "Getting pod details with wide output..."
kubectl get pods -o wide

# Appliquer le service pour exposer l'application
echo "Applying service from myservice.yaml..."
kubectl apply -f myservice.yaml

echo "Script execution complete."

