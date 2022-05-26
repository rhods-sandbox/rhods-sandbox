#! /bin/bash

echo "Make sure you are logged in as cluster admin"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

oc apply -f "${DIR}/intel/aikit-operator-subscription.yaml"
oc apply -f "${DIR}/intel/ovms-operator-subscription.yaml"

echo "Waiting for 60s to allow operators to install"

oc wait subscription/aikit-operator -n openshift-operators --for=jsonpath='{.status.state}'=AtLatestKnown --timeout=60s
AIKIT_CSV=$(oc get subscription aikit-operator -n openshift-operators -o jsonpath='{.status.installedCSV}')
oc wait csv/${AIKIT_CSV} -n openshift-operators --for=jsonpath='{.status.phase}'=Succeeded --timeout=60s

oc wait subscription/ovms-operator -n openshift-operators --for=jsonpath='{.status.state}'=AtLatestKnown --timeout=60s
OVMS_CSV=$(oc get subscription ovms-operator -n openshift-operators -o jsonpath='{.status.installedCSV}')
oc wait csv/${OVMS_CSV} -n openshift-operators --for=jsonpath='{.status.phase}'=Succeeded --timeout=60s

oc apply -f "${DIR}/intel/AIKitContainer-resource.yaml"
oc apply -f "${DIR}/intel/openvino-notebook-resource.yaml"
