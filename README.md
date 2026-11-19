[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/apache-apisix?utm_medium=integration&utm_source=button&utm_campaign=apisix)

# Apache APISIX on Railway

A one-click Railway template for [Apache APISIX](https://apisix.apache.org/) **3.20.0**, the cloud-native API and AI gateway, with its configuration store (etcd) and its built-in dashboard.

## What it deploys

| Service | Folder | What it does | Public |
|---|---|---|---|
| `apisix` | [`apisix/`](apisix) | The gateway (`apache/apisix:3.20.0-debian`, pinned by digest). Takes your API traffic on port 9080; Admin API on private port 9180; health check `/status/ready` on port 7085. | yes (gateway traffic) |
| `etcd` | [`etcd/`](etcd) | etcd v3.6.17, single node, with authentication on. Stores every route, upstream, consumer, plugin and SSL object. Data on a volume at `/var/lib/etcd`. | no |
| `dashboard` | [`dashboard/`](dashboard) | Caddy 2.11.9 reverse proxy that publishes the APISIX dashboard (`/ui/`) and Admin API (`/apisix/admin/`) on their own HTTPS domain. | yes (admin) |

All services build from this repository, so Railway tells deployers when a new version lands on `main`.

## Variables

Nothing to fill in: every value is generated or referenced.

| Service | Variable | Default | Purpose |
|---|---|---|---|
| apisix | `APISIX_ADMIN_KEY` | `${{secret(32)}}` | Admin API key, also used to log in to the dashboard |
| apisix | `APISIX_KEYRING` | `${{secret(32)}}` | Key that encrypts SSL keys and secret plugin fields in etcd. Never change it after first use |
| apisix | `APISIX_ETCD_HOST` | `${{etcd.RAILWAY_PRIVATE_DOMAIN}}` | etcd host on the private network |
| apisix | `APISIX_ETCD_PASSWORD` | `${{etcd.ETCD_ROOT_PASSWORD}}` | etcd root password |
| apisix | `PORT` | `7085` | Port Railway's health check uses (APISIX status server) |
| etcd | `ETCD_ROOT_PASSWORD` | `${{secret(32)}}` | etcd root password, set on first boot |
| etcd | `PORT` | `2379` | etcd client port |
| dashboard | `APISIX_ADMIN_URL` | `http://${{apisix.RAILWAY_PRIVATE_DOMAIN}}:9180` | Where the dashboard proxy finds the Admin API |
| dashboard | `PORT` | `8080` | Port Caddy listens on |

Optional: `APISIX_WORKER_PROCESSES` on `apisix` (default `2`) sets the number of NGINX workers.

## After deploying

1. Open the `dashboard` service's domain. It redirects to `/ui/`.
2. Copy `APISIX_ADMIN_KEY` from the `apisix` service's variables and enter it in the dashboard's settings.
3. Add an upstream and a route. Your routes answer on the `apisix` service's domain.

Admin API from the command line:

```sh
curl https://YOUR-DASHBOARD-DOMAIN/apisix/admin/routes -H "X-API-KEY: YOUR-ADMIN-KEY"
```

## Updates

The image versions are pinned in each service's `Dockerfile`. When a new APISIX version is tested, it is merged to `main` with an entry in [`CHANGELOG.md`](CHANGELOG.md), and Railway shows deployers an "update available" notice. Read the changelog first; your routes stay in etcd across updates.

## Not included

- Stream (TCP/UDP) proxying: Railway's public domains carry HTTP only.
- APISIX's own TLS listener (9443): Railway terminates TLS at its edge.
- Standalone (YAML) mode and control-plane/data-plane split.

## Licence

Apache APISIX and etcd are Apache-2.0. The wrapper files in this repository are Apache-2.0 too.
