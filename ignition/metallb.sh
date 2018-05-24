#!/bin/bash

set -e
set -o pipefail

echo "Starting MetalLB"
kubectl create -f /opt/slate/cfg/metallb.yaml
