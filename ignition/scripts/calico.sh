#!/bin/bash
PATH=$PATH:/opt/slate/bin

set -e
set -o pipefail

echo "Starting Calico"
kubectl create -f /opt/slate/cfg/calico-rbac.yaml
kubectl create -f /opt/slate/cfg/calico.yaml
