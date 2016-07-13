FROM alpine:3.4
MAINTAINER Infrastructure @ Unbounce

ENV GLIBC_VERSION 2.23-r3
ENV GLIBC_RELEASE_URL https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}
ENV GLIBC_KEY_URL https://raw.githubusercontent.com/andyshinn/alpine-pkg-glibc/master/andyshinn.rsa.pub
ENV GLIBC_KEY_PATH /etc/apk/keys/andyshinn.rsa.pub

RUN apk add --no-cache \
    curl \
    ca-certificates \
    libgcc

RUN curl \
    --silent \
    --show-error \
    --location ${GLIBC_KEY_URL} \
    --output ${GLIBC_KEY_PATH} \
  && curl \
    --silent \
    --show-error \
    --location "${GLIBC_RELEASE_URL}/glibc-${GLIBC_VERSION}.apk" \
    --output /tmp/glibc-${GLIBC_VERSION}.apk \
  && curl \
    --silent \
    --show-error \
    --location "${GLIBC_RELEASE_URL}/glibc-bin-${GLIBC_VERSION}.apk" \
    --output /tmp/glibc-bin-${GLIBC_VERSION}.apk \
  && apk add --no-cache --allow-untrusted \
    /tmp/glibc-${GLIBC_VERSION}.apk \
    /tmp/glibc-bin-${GLIBC_VERSION}.apk \
  && rm -rf /tmp/glibc* \
  && rm ${GLIBC_KEY_PATH}

RUN curl \
  --silent \
  --show-error \
  --location https://github.com/ssllabs/ssllabs-scan/releases/download/v1.3.0/ssllabs-scan_1.3.0-linux64.tgz \
  --output /tmp/ssllabs-scan.tgz
RUN tar xfz /tmp/ssllabs-scan.tgz -C /usr/local/bin/
RUN chmod 755 /usr/local/bin/ssllabs-scan

ENTRYPOINT ["ssllabs-scan"]

