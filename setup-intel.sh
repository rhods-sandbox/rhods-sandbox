#! /bin/bash

echo "Make sure you are logged in as cluster admin"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

oc apply -f "${DIR}/intel/aikit-operator-subscription.yaml"
oc apply -f "${DIR}/intel/ovms-operator-subscription.yaml"

echo "Waiting for 60s to allow operators to install"
oc wait csv/aikit-operator.v2021.2.102120 -n openshift-operators --for=jsonpath='{.status.phase}'=Succeeded --timeout=60s
oc wait csv/openvino-operator.v1.0.0 -n openshift-operators --for=jsonpath='{.status.phase}'=Succeeded --timeout=60s

oc apply -f "${DIR}/intel/AIKitContainer-resource.yaml"
oc apply -f "${DIR}/intel/openvino-notebook-resource.yaml"
