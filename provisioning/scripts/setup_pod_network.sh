#!/usr/bin/bash

set -euox pipefail

TIGERA_OPERATOR_VERSION=3.30.0

kubectl=/opt/bin/kubectl

# Wait for kubeadm.service to finish
until [ -f /home/core/kubeadm_complete ]
do
  sleep 10
done

# Remove kubeadm system service complete signalling file
rm -f /home/core/kubeadm_complete

# Install Tigera operator
$kubectl create --filename=https://raw.githubusercontent.com/projectcalico/calico/v${TIGERA_OPERATOR_VERSION}/manifests/tigera-operator.yaml

# Wait for Tigera operator to finish installation
$kubectl --namespace=tigera-operator rollout status deployment tigera-operator --timeout=120s
sleep 15

# Install Calico
$kubectl create --filename=/home/core/calico.yaml

# Wait for the calico-system namespace to be created
$kubectl wait --for=create namespace/calico-system --timeout=120s
sleep 15

# Wait for Calico to finish installation
$kubectl --namespace=calico-system wait --for=jsonpath=.status.numberReady=1 daemonset.apps/calico-node --timeout=120s
