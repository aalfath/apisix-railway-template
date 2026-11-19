#!/bin/sh
# Starts etcd and, on first boot, creates the root user and turns auth on.
set -eu

: "${ETCD_ROOT_PASSWORD:?set ETCD_ROOT_PASSWORD}"

# Single-node defaults; any ETCD_* variable set on the service wins.
# The data lives in a subfolder of the volume (the volume root holds lost+found).
export ETCD_NAME="${ETCD_NAME:-apisix-etcd}"
export ETCD_DATA_DIR="${ETCD_DATA_DIR:-/var/lib/etcd/data}"
export ETCD_LISTEN_CLIENT_URLS="${ETCD_LISTEN_CLIENT_URLS:-http://[::]:2379}"
export ETCD_ADVERTISE_CLIENT_URLS="${ETCD_ADVERTISE_CLIENT_URLS:-http://127.0.0.1:2379}"
export ETCD_LISTEN_PEER_URLS="${ETCD_LISTEN_PEER_URLS:-http://127.0.0.1:2380}"
export ETCD_INITIAL_ADVERTISE_PEER_URLS="${ETCD_INITIAL_ADVERTISE_PEER_URLS:-http://127.0.0.1:2380}"
export ETCD_INITIAL_CLUSTER="${ETCD_INITIAL_CLUSTER:-$ETCD_NAME=http://127.0.0.1:2380}"
export ETCD_AUTO_COMPACTION_MODE="${ETCD_AUTO_COMPACTION_MODE:-periodic}"
export ETCD_AUTO_COMPACTION_RETENTION="${ETCD_AUTO_COMPACTION_RETENTION:-1h}"
export ETCD_QUOTA_BACKEND_BYTES="${ETCD_QUOTA_BACKEND_BYTES:-2147483648}"
mkdir -p "$ETCD_DATA_DIR"
chmod 700 "$ETCD_DATA_DIR"

etcd &
pid=$!
trap 'kill -TERM "$pid"' TERM INT

export ETCDCTL_ENDPOINTS=http://127.0.0.1:2379
until etcdctl endpoint health >/dev/null 2>&1 || etcdctl --user "root:$ETCD_ROOT_PASSWORD" endpoint health >/dev/null 2>&1; do
  kill -0 "$pid" 2>/dev/null || exit 1
  sleep 1
done

if ! etcdctl --user "root:$ETCD_ROOT_PASSWORD" auth status 2>/dev/null | grep -q "Authentication Status: true"; then
  echo "[railway] first boot: creating the etcd root user and enabling auth"
  etcdctl user get root >/dev/null 2>&1 || etcdctl user add root --new-user-password="$ETCD_ROOT_PASSWORD" >/dev/null
  etcdctl user grant-role root root >/dev/null 2>&1 || true
  etcdctl auth enable
fi

# Keep waiting after a TERM so etcd finishes its shutdown before the container exits.
status=0
wait "$pid" || status=$?
while kill -0 "$pid" 2>/dev/null; do
  wait "$pid" || status=$?
done
exit "$status"
