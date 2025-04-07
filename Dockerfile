FROM alpine:3.21.3

LABEL \
    org.opencontainers.image.authors="Richard Kojedzinszky <richard@kojedz.in>" \
    org.opencontainers.image.title="ISC KEA dhcp server" \
    org.opencontainers.image.description="ISC KEA dhcp server"

RUN adduser -u 27489 -D -H kea && \
    mkdir /var/lib/kea /var/run/kea && chown kea:kea /var/lib/kea /var/run/kea && \
    apk --no-cache add jq kea-dhcp4 kea-dhcp6 kea-admin postgresql-client mariadb-client && \
    apk --no-cache add -t cap libcap && \
    setcap cap_net_bind_service=+ep /usr/sbin/kea-dhcp4 && \
    setcap cap_net_bind_service=+ep /usr/sbin/kea-dhcp6 && \
    apk --no-cache del cap

ADD assets/ /

USER 27489

EXPOSE 67/udp

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["/usr/sbin/kea-dhcp4", "-c", "/etc/kea/kea-dhcp4.conf"]
