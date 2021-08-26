#! /bin/bash

echo "Make sure you are logged in as cluster admin"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

oc process -f "${DIR}/sandbox/nstemplatetiers/rhods-base.yaml" | oc delete -n toolchain-host-operator -f -
oc process -f "${DIR}/sandbox/nstemplatetiers/rhods-baseextended.yaml" | oc delete -n toolchain-host-operator -f -
oc process -f "${DIR}/sandbox/nstemplatetiers/rhods-basedeactivationdisabled.yaml" | oc delete -n toolchain-host-operator -f -
oc process -f "${DIR}/sandbox/nstemplatetiers/rhods-advanced.yaml" | oc delete -n toolchain-host-operator -f -

oc process -f "${DIR}/sandbox/host-operator-secret.yaml" \
  | oc apply -n toolchain-host-operator -f -