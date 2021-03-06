#!/bin/bash
PATH=$PATH:/opt/slate/bin

set -e
set -o pipefail

echo "Initializing Kubernetes."
kubeadm init --config=/opt/slate/cfg/kubeadm.yaml

mkdir -p $HOME/.kube
cp /etc/kubernetes/admin.conf $HOME/.kube/config

mkdir -p /home/core/.kube
cp /etc/kubernetes/admin.conf /home/core/.kube/config
chown core:core /home/core/.kube/config
# hack but it works
# for single mode
kubectl taint nodes --all node-role.kubernetes.io/master-
