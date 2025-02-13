FROM debian:sid

ARG BW_CLI_VERSION

RUN apt update && \
    apt install -y tini unzip wget && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* && \
    wget "https://github.com/bitwarden/clients/releases/download/cli-v${BW_CLI_VERSION}/bw-oss-linux-sha256-${BW_CLI_VERSION}.txt" --no-verbose -O bw.zip.sha256 && \
    wget "https://github.com/bitwarden/clients/releases/download/cli-v${BW_CLI_VERSION}/bw-oss-linux-${BW_CLI_VERSION}.zip" --no-verbose -O bw.zip && \
    echo "$(cat bw.zip.sha256) bw.zip" | sha256sum --check - && \
    unzip bw.zip && \
    chmod +x bw && \
    mv bw /usr/local/bin/bw && \
    rm -rfv bw.zip* && \
    mkdir /bw && \
    groupadd --gid 1000 bw && \
    useradd --system --uid 1000 --no-create-home --shell /bin/false --home /bw --gid 1000 bw && \
    echo "bw:supersecret" | chpasswd && \
    chown -R bw:0 /bw && \
    chmod -R g=u /bw

COPY entrypoint.sh /
USER bw
WORKDIR /bw

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/entrypoint.sh"]
