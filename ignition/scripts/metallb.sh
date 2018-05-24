#!/bin/bash
PATH=$PATH:/opt/slate/bin

set -e
set -o pipefail

echo "Starting MetalLB"
kubectl create -f /opt/slate/cfg/metallb.yaml
