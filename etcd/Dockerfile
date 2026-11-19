# Single-node etcd with authentication, the configuration store for APISIX.
FROM gcr.io/etcd-development/etcd:v3.6.17@sha256:f84fa13db51b1458a5a51d7eb3fa303c179dd28f5d337935418a5bae4a305e5f AS etcd

FROM alpine:3.24.4@sha256:f59abe656b692d901e184be3445e084786602108599d2a51d229c0f5a48c71bf
COPY --from=etcd /usr/local/bin/etcd /usr/local/bin/etcdctl /usr/local/bin/etcdutl /usr/local/bin/
COPY --chmod=0755 start.sh /usr/local/bin/start.sh
EXPOSE 2379
# start.sh stays PID 1: it forwards SIGTERM to etcd and waits for a clean shutdown.
ENTRYPOINT ["/usr/local/bin/start.sh"]
