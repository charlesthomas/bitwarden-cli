FROM debian:sid

ARG BW_CLI_VERSION=2025.12.0

RUN apt update && \
    apt install -y wget unzip && \
    wget https://github.com/bitwarden/clients/releases/download/cli-v${BW_CLI_VERSION}/bw-oss-linux-${BW_CLI_VERSION}.zip && \
    unzip bw-linux-${BW_CLI_VERSION}.zip && \
    chmod +x bw && \
    mv bw /usr/local/bin/bw && \
    rm -rfv *.zip

COPY entrypoint.sh /

CMD ["/entrypoint.sh"]
