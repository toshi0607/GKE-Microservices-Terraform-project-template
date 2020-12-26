# https://hub.docker.com/_/golang
FROM golang:1.14.12-stretch
RUN apt-get update && apt-get install -y --no-install-recommends unzip

ENV TERRAFORM_VERSION=0.13.5 \
    CLOUD_SDK_VERSION=319.0.0 \
    CONFTEST_VERSION=0.22.0

RUN wget -q -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && cd /tmp \
    && unzip -q terraform.zip \
    && mv terraform /usr/bin/terraform \
    && chmod +x /usr/bin/terraform \
    && rm /tmp/terraform.zip

RUN wget -q -O /tmp/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
    && cd /tmp \
    && tar zxf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
    && google-cloud-sdk/install.sh \
    && mv /tmp/google-cloud-sdk /google-cloud-sdk \
    && rm /tmp/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz

RUN mkdir -p /tmp/conftest \
    && wget -q -O /tmp/conftest/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz https://github.com/instrumenta/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz \
    && cd /tmp/conftest \
    && tar zxf conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz \
    && mv conftest /usr/local/bin/ \
    && cd / \
    && rm -rf /tmp/conftest

ENV PATH /google-cloud-sdk/bin:$PATH

RUN gcloud components install kubectl
