FROM debian:sid

ARG BW_CLI_VERSION
# See also https://bitwarden.com/help/cli/#log-in-to-multiple-accounts for this env var.
# By default it is composed as "~/Bitwarden CLI" but we don't want that, we want more control,
# make the app write the config to /bw/data.json
ENV BITWARDENCLI_APPDATA_DIR=/bw

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
    mkdir "${BITWARDENCLI_APPDATA_DIR}" && \
    groupadd --gid 1000 bw && \
    useradd --system --uid 1000 --no-create-home --shell /bin/false --home "${BITWARDENCLI_APPDATA_DIR}" --gid 1000 bw && \
    echo "bw:supersecret" | chpasswd && \
    chown -R bw:0 "${BITWARDENCLI_APPDATA_DIR}" && \
    chmod -R g=u "${BITWARDENCLI_APPDATA_DIR}"

COPY entrypoint.sh /
USER bw
WORKDIR "${BITWARDENCLI_APPDATA_DIR}"

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/entrypoint.sh"]
