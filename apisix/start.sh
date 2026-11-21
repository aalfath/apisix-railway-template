#!/usr/bin/env bash
# Wait for etcd before APISIX runs `init_etcd`: Railway starts all services at
# once on the first deploy. After 3 minutes we hand over anyway, so a missing
# etcd shows up as APISIX's own error instead of a silent hang.
set -euo pipefail

: "${APISIX_ETCD_HOST:?set APISIX_ETCD_HOST to the etcd service host}"
: "${APISIX_ETCD_PASSWORD:?set APISIX_ETCD_PASSWORD to the etcd root password}"
: "${APISIX_ADMIN_KEY:?set APISIX_ADMIN_KEY}"
: "${APISIX_KEYRING:?set APISIX_KEYRING (16 or 32 characters)}"
case "${#APISIX_KEYRING}" in
  16|32) ;;
  *) echo "APISIX_KEYRING must be 16 or 32 characters long" >&2; exit 1 ;;
esac

port="${APISIX_ETCD_PORT:-2379}"
echo "[railway] waiting for etcd at ${APISIX_ETCD_HOST}:${port}"
# Each attempt gets a 3 s connect timeout: when etcd is redeployed at the same
# time, its old private address can swallow the SYN and a bare /dev/tcp connect
# then hangs for minutes, close to Railway's health-check limit.
for i in $(seq 1 90); do
  if timeout 3 bash -c 'exec 3<>"/dev/tcp/$0/$1"' "${APISIX_ETCD_HOST}" "${port}" 2>/dev/null; then
    echo "[railway] etcd reachable after ${i} attempt(s)"
    break
  fi
  sleep 2
done

exec /docker-entrypoint.sh docker-start
