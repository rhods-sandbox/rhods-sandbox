#!/usr/bin/env bash

# This script will query all of the JH users to see if they have an existing OCP user
#   If no OCP user exists then:
#     - Stop the notebook server
#     - Remove the user's entry in JupyterHub
#     - Delete the user's singleuserprofile ConfigMap
#     - Delete the user's singleuserprofile Secret
#     - Delete the user's PVC

echo "JupyterHub API token: ${JUPYTERHUB_API_TOKEN}";

JUPYTERHUB_USER_LIST=$(curl -s -k -X GET -H "Authorization: token ${JUPYTERHUB_API_TOKEN}" ${JUPYTERHUB_API_URL}/users | jq -r '.[].name')

echo "JupyterHub users: ${JUPYTERHUB_USER_LIST}"

for JUPYTERHUB_USERNAME in ${JUPYTERHUB_USER_LIST};
do
  if [[ ${JUPYTERHUB_USERNAME} = "admin" || ${JUPYTERHUB_USERNAME} = "kube:admin" ]];
  then
    continue;
  fi

  oc get user ${JUPYTERHUB_USERNAME} > /dev/null

  if [[ $? != 0 ]];
  then
    echo "OCP user (${JUPYTERHUB_USERNAME}) NOT FOUND. Cleaning up artifacts"
    JUPYTERHUB_USERNAME_TRANSLATED=$(echo ${JUPYTERHUB_USERNAME} | sed 's/-/-2d/g' | sed 's/@/-40/g' | sed 's/\./-2e/g'| sed 's/:/-3a/g')

    curl -s -k -X DELETE -H "Authorization: token ${JUPYTERHUB_API_TOKEN}" ${JUPYTERHUB_API_URL}/users/${JUPYTERHUB_USERNAME}/server > /dev/null

    curl -s -k -X DELETE -H "Authorization: token ${JUPYTERHUB_API_TOKEN}" ${JUPYTERHUB_API_URL}/users/${JUPYTERHUB_USERNAME} > /dev/null

    oc delete -n ${JUPYTERHUB_APPLICATION_NAMESPACE} cm jupyterhub-singleuser-profile-${JUPYTERHUB_USERNAME_TRANSLATED}

    oc delete -n ${JUPYTERHUB_NOTEBOOK_NAMESPACE} cm jupyterhub-singleuser-profile-${JUPYTERHUB_USERNAME_TRANSLATED}-envs

    oc delete -n ${JUPYTERHUB_NOTEBOOK_NAMESPACE} secret jupyterhub-singleuser-profile-${JUPYTERHUB_USERNAME_TRANSLATED}-envs

    oc delete -n ${JUPYTERHUB_NOTEBOOK_NAMESPACE} pvc jupyterhub-nb-${JUPYTERHUB_USERNAME_TRANSLATED}-pvc
  else
    echo "SKIPPING user: ${JUPYTERHUB_USERNAME}";
  fi
done
