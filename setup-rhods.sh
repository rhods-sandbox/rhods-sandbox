#! /bin/bash

echo "Make sure you are logged in as cluster admin"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

oc patch configmap jupyterhub-cfg -n redhat-ods-applications --patch-file "${DIR}/rhods/jupyterhub-cfg-patch.yaml"
oc patch configmap rhods-groups-config -n redhat-ods-applications --patch-file "${DIR}/rhods/rhods-groups-config-patch.yaml"
oc patch configmap rhods-jupyterhub-sizes -n redhat-ods-applications --patch-file "${DIR}/rhods/rhods-jupyterhub-sizes-patch.yaml"
oc patch configmap odh-jupyterhub-global-profile -n redhat-ods-applications --patch-file "${DIR}/rhods/odh-jupyterhub-global-profile-patch.yaml"
oc rollout latest deploymentconfig/jupyterhub -n redhat-ods-applications

oc apply -n redhat-ods-applications -f "${DIR}/rhods/odh-dashboard-config.yaml"
oc rollout restart deployment/rhods-dashboard -n redhat-ods-applications

oc apply -f "${DIR}/rhods/cleanup-sandbox-user.cronjob.yaml"
