#! /bin/bash

echo "Make sure you are logged in as cluster admin"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

oc delete configmap notebook-controller-culler-config -n redhat-ods-applications
oc apply -n redhat-ods-applications -f "${DIR}/rhods/odh-dashboard-config-original.yaml"
oc rollout restart deployment/rhods-dashboard -n redhat-ods-applications

oc delete -f "${DIR}/rhods/cleanup-sandbox-user.cronjob.yaml"
