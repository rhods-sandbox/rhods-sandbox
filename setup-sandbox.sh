#! /bin/bash

echo "Make sure you are logged in as cluster admin"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

oc process -f "${DIR}/sandbox/nstemplatetiers/rhods-base.yaml" | oc apply -n toolchain-host-operator -f -
oc process -f "${DIR}/sandbox/nstemplatetiers/rhods-baseextended.yaml" | oc apply -n toolchain-host-operator -f -
oc process -f "${DIR}/sandbox/nstemplatetiers/rhods-basedeactivationdisabled.yaml" | oc apply -n toolchain-host-operator -f -
oc process -f "${DIR}/sandbox/nstemplatetiers/rhods-advanced.yaml" | oc apply -n toolchain-host-operator -f -

oc process -f "${DIR}/sandbox/host-operator-secret.yaml" \
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
