echo "Make sure you are logged in as kubeadmin"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

oc apply -n redhat-ods-applications -f "${DIR}/rhods/odh-dashboard-config.yaml"
oc rollout restart deployment/odh-dashboard -n redhat-ods-applications

oc patch configmap rhods-groups-config -n redhat-ods-applications --patch-file "${DIR}/rhods/rhods-groups-config-patch.yaml"
oc patch configmap odh-jupyterhub-sizes -n redhat-ods-applications --patch-file "${DIR}/rhods/odh-jupyterhub-sizes-patch.yaml"
oc rollout latest deploymentconfig/jupyterhub-db -n redhat-ods-applications
oc rollout latest deploymentconfig/jupyterhub -n redhat-ods-applications

oc process -f "${DIR}/nstemplatetiers/rhods-base.yaml" | oc apply -n toolchain-host-operator -f -
oc process -f "${DIR}/nstemplatetiers/rhods-baseextended.yaml" | oc apply -n toolchain-host-operator -f -
oc process -f "${DIR}/nstemplatetiers/rhods-basedeactivationdisabled.yaml" | oc apply -n toolchain-host-operator -f -
oc process -f "${DIR}/nstemplatetiers/rhods-advanced.yaml" | oc apply -n toolchain-host-operator -f -