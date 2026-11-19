# Single-node etcd with authentication, the configuration store for APISIX.
FROM quay.io/coreos/etcd:v3.6.17@sha256:316f5d367455f75a327f9dc72f669cbf645651859fa2e272f692a1f2dee6f5c9 AS etcd

FROM alpine:3.24.4@sha256:f59abe656b692d901e184be3445e084786602108599d2a51d229c0f5a48c71bf
RUN apk add --no-cache tini
COPY --from=etcd /usr/local/bin/etcd /usr/local/bin/etcdctl /usr/local/bin/etcdutl /usr/local/bin/
COPY --chmod=0755 start.sh /usr/local/bin/start.sh
EXPOSE 2379
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/start.sh"]
