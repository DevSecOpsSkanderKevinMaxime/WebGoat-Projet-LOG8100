#!/bin/bash

echo "Starting Minikube with two nodes..."
minikube addons enable ingress
minikube start --driver=docker --nodes=2

alias kubectl="minikube kubectl --"

echo "Waiting for Minikube nodes to be ready..."
sleep 30  # Adjust this wait time as needed to ensure nodes are up

# Retrieve node names
nodes=($(kubectl get nodes -o jsonpath='{.items[*].metadata.name}'))

if [ ${#nodes[@]} -ge 2 ]; then
  # Label the first node as development
  kubectl label node "${nodes[0]}" environment=development --overwrite
  echo "Labeled ${nodes[0]} as development"

  # Label the second node as production
  kubectl label node "${nodes[1]}" environment=production --overwrite
  echo "Labeled ${nodes[1]} as production"
else
  echo "Not enough nodes available for labeling."
  exit 1

fi
