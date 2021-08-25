echo "Make sure you are logged in as kubeadmin"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

oc process -n redhat-ods-applications -f "${DIR}/rhods/jupyterhub-idle-culler.yaml" | oc delete -f -

oc delete configmap odh-dashboard-config -n redhat-ods-applications
oc rollout restart deployment/odh-dashboard -n redhat-ods-applications

oc patch configmap rhods-groups-config -n redhat-ods-applications --patch-file "${DIR}/rhods/rhods-groups-config-original-patch.yaml"
oc patch configmap jupyter-singleuser-profiles -n redhat-ods-applications --patch-file "${DIR}/rhods/jupyter-singleuser-profiles-original-patch.yaml"
oc patch configmap rhods-jupyterhub-sizes -n redhat-ods-applications --patch-file "${DIR}/rhods/rhods-jupyterhub-sizes-original-patch.yaml"
oc rollout latest deploymentconfig/jupyterhub -n redhat-ods-applications

oc process -f "${DIR}/nstemplatetiers/rhods-base.yaml" | oc delete -n toolchain-host-operator -f -
oc process -f "${DIR}/nstemplatetiers/rhods-baseextended.yaml" | oc delete -n toolchain-host-operator -f -
oc process -f "${DIR}/nstemplatetiers/rhods-basedeactivationdisabled.yaml" | oc delete -n toolchain-host-operator -f -
oc process -f "${DIR}/nstemplatetiers/rhods-advanced.yaml" | oc delete -n toolchain-host-operator -f -

oc process -f "${DIR}/sandbox-secrets/host-operator-secret.yaml" \
  | oc apply -n toolchain-host-operator -f -