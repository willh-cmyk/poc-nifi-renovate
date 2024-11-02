FROM registry.access.redhat.com/ubi8/python-39

ARG CUSTOM_DOCKERFILE_RUN
ARG PRODUCT_VERSION=2.0.0
ENV NIFI_BASE_FIR=/opt/nifi

ARG NIFI_VERSION=1.22.0

ENV NIFI_BASE_DIR=/opt/nifi \
    NIFI_VERSION=${NIFI_VERSION}

COPY GPG-KEY-nifi nifi-${NIFI_VERSION}-bin.zip.sha512 nifi-${NIFI_VERSION}-bin.zip.asc ./

USER root

RUN yum install -y diffutils \
    && curl https://archive.apache.org/dist/nifi/${NIFI_VERSION}/nifi-${NIFI_VERSION}-bin.zip -O \
    && sha512sum nifi-${NIFI_VERSION}-bin.zip | awk '{ print $1 }' | diff - nifi-${NIFI_VERSION}-bin.zip.sha512 \
    && gpg --import GPG-KEY-nifi \
    && gpg --verify nifi-${NIFI_VERSION}-bin.zip.asc nifi-${NIFI_VERSION}-bin.zip
