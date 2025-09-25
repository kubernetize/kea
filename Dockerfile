FROM ghcr.io/kubernetize/alpine-service-base

LABEL \
    org.opencontainers.image.authors="Richard Kojedzinszky <richard@kojedz.in>" \
    org.opencontainers.image.title="ISC KEA dhcp server" \
    org.opencontainers.image.description="ISC KEA dhcp server"

ADD assets/ /

RUN adduser -u 27489 -D -H kea && \
    mkdir /var/lib/kea /var/run/kea && chown kea:kea /var/lib/kea /var/run/kea && \
    apk --no-cache add jq yq kea-dhcp4 kea-dhcp6 kea-admin postgresql-client mariadb-client && \
    apk --no-cache add -t setup patch && \
    cd /usr/sbin && patch -p0 < kea-admin.patch && cd / && \
    apk --no-cache del setup

USER 27489

EXPOSE 67/udp
