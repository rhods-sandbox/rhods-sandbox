#! /bin/bash

echo "Make sure you are logged in as cluster admin"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

OPENVINO_NOTEBOOK=$(oc get Notebook -n redhat-ods-applications -o name)
echo "deleting Openvino Notebook resource"
oc delete $OPENVINO_NOTEBOOK -n redhat-ods-applications

OVMS_CSV=$(oc get subscription ovms-operator -n openshift-operators -o jsonpath='{.status.installedCSV}')
echo "deleting sub ovms-operator"
echo "deleting csv ${OVMS_CSV}"
oc delete subscription ovms-operator -n openshift-operators
oc delete clusterserviceversion ${OVMS_CSV} -n openshift-operators

AIKIT_CONTAINER_NAME=$(oc get AIKitContainer -n redhat-ods-applications -o name)
echo "deleting AIKit Container resource"
oc delete $AIKIT_CONTAINER_NAME -n redhat-ods-applications

AIKIT_CSV=$(oc get subscription aikit-operator -n openshift-operators -o jsonpath='{.status.installedCSV}')
echo "deleting sub aikit-operator"
echo "deleting csv ${AIKIT_CSV}"
oc delete subscription aikit-operator -n openshift-operators
oc delete clusterserviceversion ${AIKIT_CSV} -n openshift-operators
