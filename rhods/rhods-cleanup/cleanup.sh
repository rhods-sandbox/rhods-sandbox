#!/usr/bin/env bash

# This script will query all of the notebooks and make sure there user still exists
#   If no OCP user exists then:
#     - Delete the notebook resource
#     - Delete the user's singleuserprofile ConfigMap
#     - Delete the user's singleuserprofile Secret
#     - Delete the user's PVC

echo "RHODS_NOTEBOOKS_NAMESPACE namespace set to ${RHODS_NOTEBOOKS_NAMESPACE}"

NOTEBOOKS=$(oc get notebook.kubeflow.org -n "${RHODS_NOTEBOOKS_NAMESPACE}" -o name)

for NOTEBOOK in ${NOTEBOOKS};
do
  echo " checking ${NOTEBOOK} user still exists"
  TRANSLATED_USERNAME=$(echo ${NOTEBOOK} | sed 's|notebook.kubeflow.org/jupyter-nb-||g')
  OCP_USERNAME=$(echo ${TRANSLATED_USERNAME} | sed 's/-2d/-/g' | sed 's/-40/@/g' | sed 's/-2e/\./g'| sed 's/-3a/:/g')
  echo " ${OCP_USERNAME}"

  oc get user ${OCP_USERNAME} > /dev/null

  if [[ $? != 0 ]];
  then
    echo "OCP user (${OCP_USERNAME}) NOT FOUND. Cleaning up artifacts"

    oc delete -n ${RHODS_NOTEBOOKS_NAMESPACE} notebooks.kubeflow.org jupyter-nb-${TRANSLATED_USERNAME}

    oc delete -n ${RHODS_NOTEBOOKS_NAMESPACE} cm jupyterhub-singleuser-profile-${TRANSLATED_USERNAME}-envs

    oc delete -n ${RHODS_NOTEBOOKS_NAMESPACE} secret jupyterhub-singleuser-profile-${TRANSLATED_USERNAME}-envs

    oc delete -n ${RHODS_NOTEBOOKS_NAMESPACE} pvc jupyterhub-nb-${TRANSLATED_USERNAME}-pvc
  else
    echo "SKIPPING user: ${OCP_USERNAME}";
  fi
done

