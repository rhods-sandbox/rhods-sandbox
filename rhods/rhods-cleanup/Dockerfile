# This image is just to allow the use of jq to parse the oc cli json output
FROM registry.redhat.io/openshift4/ose-cli:v4.9

RUN yum install -y --quiet \
    jq \
    && yum clean all

COPY cleanup.sh /usr/bin/cleanup.sh

USER 1001
