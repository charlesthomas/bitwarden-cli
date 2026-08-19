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

# hostname

`bw serve` 2026.6.0 added a Host header allowlist on top of its existing Origin header
check. with `--hostname 0.0.0.0` the allowlist only contains `localhost`, `127.0.0.1`,
`[::1]` and `0.0.0.0` at the serve port, so reaching the container over a docker or
kubernetes service name (e.g. `bitwarden-cli.my-namespace.svc:8087`) is rejected with:

```
Blocking request with disallowed Host "..."
```

this image runs `bw serve --hostname all`, which binds every interface and skips the Host
allowlist while leaving the Origin header check active. older cli releases accept `all`
too, so the same entrypoint works either side of 2026.6.0.

this is preferable to `--disable-origin-protection`, which turns off both checks.
