# Apache APISIX gateway for Railway (traditional mode, configuration in etcd).
FROM apache/apisix:3.21.0-debian@sha256:1741a8e1186e5c39ea10e6b4fb3e682534d1705efb8328195de5b41ad0657380

USER root
COPY --chown=apisix:apisix config.yaml /usr/local/apisix/conf/config.yaml
COPY --chmod=0755 start.sh /usr/local/bin/railway-start.sh
USER apisix

EXPOSE 9080 9180 7085
# The image's ENTRYPOINT (/docker-entrypoint.sh) runs this script, which waits
# for etcd and then hands over to `/docker-entrypoint.sh docker-start`.
CMD ["/usr/local/bin/railway-start.sh"]
