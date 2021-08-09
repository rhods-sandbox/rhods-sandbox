echo "Make sure you are logged in as kubeadmin"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

oc process -f "${DIR}/rhods/odh-dashboard-config.yaml" | oc apply -n redhat-ods-applications -f -
oc rollout restart deployment/odh-dashboard -n redhat-ods-applications

oc process -f "${DIR}/rhods/rhods-groups-config.yaml" | oc apply -n redhat-ods-applications -f -
oc rollout latest deploymentconfig/jupyterhub-db -n redhat-ods-applications
oc rollout latest deploymentconfig/jupyterhub -n redhat-ods-applications

oc process -f "${DIR}/nstemplatetiers/rhods-base.yaml" | oc apply -n toolchain-host-operator -f -
oc process -f "${DIR}/nstemplatetiers/rhods-baseextended.yaml" | oc apply -n toolchain-host-operator -f -
oc process -f "${DIR}/nstemplatetiers/rhods-basedeactivationdisabled.yaml" | oc apply -n toolchain-host-operator -f -
oc process -f "${DIR}/nstemplatetiers/rhods-advanced.yaml" | oc apply -n toolchain-host-operator -f -
