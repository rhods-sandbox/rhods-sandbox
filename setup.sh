echo "Make sure you are logged in"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

oc apply -n redhat-ods-applications -f "${DIR}/rhods/odh-dashboard-config.yaml"
oc rollout restart deployment/odh-dashboard -n redhat-ods-applications

oc patch configmap rhods-groups-config -n redhat-ods-applications --patch-file "${DIR}/rhods/rhods-groups-config-patch.yaml"
oc patch configmap jupyter-singleuser-profiles -n redhat-ods-applications --patch-file "${DIR}/rhods/jupyter-singleuser-profiles-patch.yaml"
oc patch configmap rhods-jupyterhub-sizes -n redhat-ods-applications --patch-file "${DIR}/rhods/rhods-jupyterhub-sizes-patch.yaml"
oc rollout latest deploymentconfig/jupyterhub -n redhat-ods-applications

oc process -f "${DIR}/nstemplatetiers/rhods-base.yaml" | oc apply -n toolchain-host-operator -f -
oc process -f "${DIR}/nstemplatetiers/rhods-baseextended.yaml" | oc apply -n toolchain-host-operator -f -
oc process -f "${DIR}/nstemplatetiers/rhods-basedeactivationdisabled.yaml" | oc apply -n toolchain-host-operator -f -
oc process -f "${DIR}/nstemplatetiers/rhods-advanced.yaml" | oc apply -n toolchain-host-operator -f -

oc process -f "${DIR}/sandbox-secrets/host-operator-secret.yaml" \
  -p MAILGUN_API_KEY="${MAILGUN_API_KEY}" \
  -p MAILGUN_DOMAIN="${MAILGUN_DOMAIN}" \
  -p MAILGUN_SENDER_EMAIL="${MAILGUN_SENDER_EMAIL}" \
  -p MAILGUN_REPLYTO_EMAIL="${MAILGUN_REPLYTO_EMAIL}" \
  -p TWILIO_ACCOUNT_SID="${TWILIO_ACCOUNT_SID}" \
  -p TWILIO_AUTH_TOKEN="${TWILIO_AUTH_TOKEN}" \
  -p TWILIO_FROM_NUMBER="${TWILIO_FROM_NUMBER}" \
  | oc apply -n toolchain-host-operator -f -

oc rollout restart deployment/registration-service -n toolchain-host-operator
oc rollout restart deployment/host-operator-controller-manager -n toolchain-host-operator
