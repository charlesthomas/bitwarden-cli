FROM alpine:latest AS downloader

ARG BW_VERSION=2025.6.1

RUN apk update --no-cache \
 && apk add --no-cache curl jq \
 && curl -sLo bw.zip "https://github.com/bitwarden/clients/releases/download/cli-v${BW_VERSION}/bw-oss-linux-${BW_VERSION}.zip" \
 && echo $(\
    curl -sL "https://api.github.com/repos/bitwarden/clients/releases/tags/cli-v${BW_VERSION}" | \
    jq -r ".assets[] | select(.name == \"bw-oss-linux-${BW_VERSION}.zip\") .digest" | \
    cut -f2 -d:) bw.zip > sum.txt \
 && sha256sum -sc sum.txt \
 && unzip bw.zip

FROM debian:sid

RUN apt-get update \
 && apt-get install -y wget \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY --from=downloader bw /usr/local/bin/

USER 1000

WORKDIR /bw

ENV HOME=/bw

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
