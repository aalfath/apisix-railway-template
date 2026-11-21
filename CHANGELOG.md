# Changelog

## 3.21.0 (2026-11-21)

**Breaking changes upstream (none need action on this template):**

- APISIX 3.21.0 requires a `role` on every Admin API key. This template's key already has `role: admin`, so nothing changes for you.
- Newly encrypted secret plugin fields are stored with an `$ENC$v1$` prefix. Data written by 3.20.0 stays readable. Once a resource has been saved under 3.21.0, rolling back to 3.20.0 needs the etcd data from before the update, so avoid rolling back after you edit consumers or plugins.
- The bundled NGINX now answers 400 to client header lines without a colon and 502 to such upstream responses.

Changes:

- Apache APISIX 3.20.0 -> 3.21.0 (`apache/apisix:3.21.0-debian`, pinned by digest). Includes fixes for ten NGINX security advisories of 2026-11-18 and stops writing sensitive values to logs. Upstream notes: https://github.com/apache/apisix/blob/3.21.0/CHANGELOG.md
- etcd (v3.6.17) and Caddy (2.11.9) unchanged.

## 3.20.0 (2026-11-19)

First release of this template.

- Apache APISIX 3.20.0 (`apache/apisix:3.20.0-debian`, pinned by digest), traditional mode with etcd.
- etcd v3.6.17 with authentication, data on a volume.
- Caddy 2.11.9 proxy for the built-in dashboard and Admin API.
