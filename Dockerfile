FROM debian:sid

ARG BW_CLI_VERSION=2025.12.1
ARG TARGETARCH

RUN apt update && \
    apt install -y wget unzip && \
    if [ "$TARGETARCH" = "arm64" ]; then \
      BW_ARCH="-arm64"; \
    else \
      BW_ARCH=""; \
    fi && \
    wget https://github.com/bitwarden/clients/releases/download/cli-v${BW_CLI_VERSION}/bw-oss-linux${BW_ARCH}-${BW_CLI_VERSION}.zip && \
    unzip bw-oss-linux${BW_ARCH}-${BW_CLI_VERSION}.zip && \
    chmod +x bw && \
    mv bw /usr/local/bin/bw && \
    rm -rfv *.zip

COPY entrypoint.sh /

CMD ["/entrypoint.sh"]
