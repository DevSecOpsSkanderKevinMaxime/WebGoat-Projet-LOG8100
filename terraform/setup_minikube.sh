#!/bin/bash

echo "Starting Minikube with two nodes..."
# on macOS we would have to set the driver to docker 
# therefore port forwarding is mandatory since docker has
# limited network accessibility
minikube start --driver=docker --nodes=2

alias kubectl="minikube kubectl --"

echo "Waiting for Minikube nodes to be ready..."
sleep 30 

nodes=($(kubectl get nodes -o jsonpath='{.items[*].metadata.name}'))

if [ ${#nodes[@]} -ge 2 ]; then
  kubectl label node "${nodes[0]}" environment=development --overwrite
  echo "Labeled ${nodes[0]} as development"

  kubectl label node "${nodes[1]}" environment=production --overwrite
  echo "Labeled ${nodes[1]} as production"
else
  echo "Not enough nodes available for labeling."
  exit 1
fi
