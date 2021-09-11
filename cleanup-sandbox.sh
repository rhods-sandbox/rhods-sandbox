#! /bin/bash

echo "Make sure you are logged in as cluster admin"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

oc project toolchain-host-operator

oc process -f "${DIR}/sandbox/nstemplatetiers/rhods-base.yaml" | oc delete -n toolchain-host-operator -f -
oc process -f "${DIR}/sandbox/nstemplatetiers/rhods-baseextended.yaml" | oc delete -n toolchain-host-operator -f -
oc process -f "${DIR}/sandbox/nstemplatetiers/rhods-basedeactivationdisabled.yaml" | oc delete -n toolchain-host-operator -f -
oc process -f "${DIR}/sandbox/nstemplatetiers/rhods-advanced.yaml" | oc delete -n toolchain-host-operator -f -

oc process -f "${DIR}/sandbox/host-operator-config.yaml" \
  | oc apply -n toolchain-host-operator -f -

oc process -f "${DIR}/sandbox/prometheus-config.yaml" \
  | oc apply -n openshift-customer-monitoring -f -
oc scale statefulset prometheus-prometheus --replicas=0 -n openshift-customer-monitoring
oc scale statefulset prometheus-prometheus --replicas=2 -n openshift-customer-monitoring

oc process -f "${DIR}/sandbox/grafana-config.yaml" \
  | oc apply -n openshift-customer-monitoring -f -
oc delete rolebinding/grafana-openshift-customer-monitoring-read-only
oc delete role/openshift-customer-monitoring-read-only
oc scale statefulset prometheus-prometheus --replicas=0 -n openshift-customer-monitoring
oc scale statefulset prometheus-prometheus --replicas=2 -n openshift-customer-monitoring