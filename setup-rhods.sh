#! /bin/bash

echo "Make sure you are logged in as cluster admin"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

oc apply -n redhat-ods-applications -f "${DIR}/rhods/notebook-controller-culler-config.yaml"
oc apply -n redhat-ods-applications -f "${DIR}/rhods/odh-dashboard-config.yaml"
oc rollout restart deployment/rhods-dashboard -n redhat-ods-applications

oc apply -f "${DIR}/rhods/cleanup-sandbox-user.cronjob.yaml"
