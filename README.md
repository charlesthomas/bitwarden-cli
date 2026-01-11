# bitwarden-cli

bitwarden-cli docker image

this is based on the code in the [external-secrets documentation](https://external-secrets.io/latest/examples/bitwarden/).

both the `Dockerfile` and `entrypoint.sh` are a near-identical copy/paste.

the only changes are to the `Dockerfile` to convert `BW_CLI_VERSION` from an `ENV` to an `ARG`,
so that the official upstream version can be read from the `VERISON` file for the `ARG` as well as the image tag

# tag convention

```bash
docker pull ghcr.io/charlesthomas/bitwarden-cli:<official bitwarden cli version>
```

check [VERSION](/VERSION) to see what the actual value is.
when this doc was created it was `2023.12.1` so the full image was:

```bash
ghcr.io/charlesthomas/bitwarden-cli:2023.12.1
```
