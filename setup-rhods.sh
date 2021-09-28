#! /bin/bash

echo "Make sure you are logged in as cluster admin"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

oc process -n redhat-ods-applications -f "${DIR}/rhods/jupyterhub-idle-culler.yaml" \
  -p IDLE_CULLER_TIMEOUT="${IDLE_CULLER_TIMEOUT}" \
  | oc apply -n redhat-ods-applications -f -

oc apply -n redhat-ods-applications -f "${DIR}/rhods/odh-dashboard-config.yaml"
oc rollout restart deployment/rhods-dashboard -n redhat-ods-applications

oc adm groups new rhods-admins || echo "rhods-admins group already exists"
oc patch configmap rhods-groups-config -n redhat-ods-applications --patch-file "${DIR}/rhods/rhods-groups-config-patch.yaml"
oc patch configmap rhods-jupyterhub-sizes -n redhat-ods-applications --patch-file "${DIR}/rhods/rhods-jupyterhub-sizes-patch.yaml"
oc patch configmap odh-jupyterhub-global-profile -n redhat-ods-applications --patch-file "${DIR}/rhods/odh-jupyterhub-global-profile-patch.yaml"
oc rollout latest deploymentconfig/jupyterhub -n redhat-ods-applications

