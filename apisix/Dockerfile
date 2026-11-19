# Apache APISIX gateway for Railway (traditional mode, configuration in etcd).
FROM apache/apisix:3.20.0-debian@sha256:013de62a9dfba7d8e6006b3e85b524c28c9f1c3549fca3b91d5b258b0b9e759a

USER root
COPY --chown=apisix:apisix config.yaml /usr/local/apisix/conf/config.yaml
COPY --chmod=0755 start.sh /usr/local/bin/railway-start.sh
USER apisix

EXPOSE 9080 9180 7085
# The image's ENTRYPOINT (/docker-entrypoint.sh) runs this script, which waits
# for etcd and then hands over to `/docker-entrypoint.sh docker-start`.
CMD ["/usr/local/bin/railway-start.sh"]
