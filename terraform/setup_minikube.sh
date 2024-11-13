#!/bin/bash

# Step 1: Start Minikube with two nodes
echo "Starting Minikube with two nodes..."
minikube start --driver=docker --nodes=2 

# Step 2: Get the list of nodes after Minikube is up
echo "Waiting for Minikube nodes to be ready..."
sleep 30  # Adjust this wait time as needed to ensure nodes are up

# Retrieve node names
nodes=($(kubectl get nodes -o jsonpath='{.items[*].metadata.name}'))

# Step 3: Check if we have at least two nodes
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