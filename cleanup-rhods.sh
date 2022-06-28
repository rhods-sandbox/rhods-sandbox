#! /bin/bash

echo "Make sure you are logged in as cluster admin"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

oc patch configmap jupyterhub-cfg -n redhat-ods-applications --patch-file "${DIR}/rhods/jupyterhub-cfg-original-patch.yaml"
oc patch configmap rhods-groups-config -n redhat-ods-applications --patch-file "${DIR}/rhods/rhods-groups-config-original-patch.yaml"
oc patch configmap rhods-jupyterhub-sizes -n redhat-ods-applications --patch-file "${DIR}/rhods/rhods-jupyterhub-sizes-original-patch.yaml"
oc patch configmap odh-jupyterhub-global-profile -n redhat-ods-applications --patch-file "${DIR}/rhods/odh-jupyterhub-global-profile-original-patch.yaml"
oc rollout latest deploymentconfig/jupyterhub -n redhat-ods-applications

oc delete configmap odh-dashboard-config -n redhat-ods-applications
oc rollout restart deployment/rhods-dashboard -n redhat-ods-applications

oc delete -f "${DIR}/rhods/cleanup-sandbox-user.cronjob.yaml"
