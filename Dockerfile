FROM debian:buster-slim AS base

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends liblog4cplus-1.1-9 libssl1.1 \
        libboost-system1.67.0 libpq5 libmariadb3 \
        postgresql-client default-mysql-client && \
    rm -rf /var/lib/apt/* /var/cache/apt/*

FROM base AS build

ENV KEA_VERSION 1.7.7

RUN apt-get update && \
    apt-get install -y make g++ automake libtool libssl-dev \
        libboost-system-dev libboost-dev liblog4cplus-dev \
        postgresql-server-dev-11 libmariadb-dev curl && \
    mkdir /kea && \
    curl -sL https://github.com/isc-projects/kea/archive/Kea-${KEA_VERSION}.tar.gz | tar xzf - --strip-components=1 -C /kea

WORKDIR /kea

RUN autoreconf --install && \
    CFLAGS=-O2 CXXFLAGS=-O2 ./configure --enable-static=no --disable-dependency-tracking \
        --sysconfdir=/etc --localstatedir=/var \
        --with-pgsql --with-mysql=/usr/bin/mariadb_config && \
    make && make install

RUN rm -rf /usr/local/include/* && \
    rm -f /usr/local/lib/*.la /usr/local/lib/kea/hooks/*.la && \
    find /usr/local/lib/ -name '*.so' -print0 | xargs -r0 strip -s && \
    strip -s /usr/local/sbin/* || true

FROM base

LABEL \
    org.opencontainers.image.authors="Richard Kojedzinszky <richard@kojedz.in>" \
    org.opencontainers.image.title="ISC KEA dhcp server" \
    org.opencontainers.image.description="ISC KEA dhcp server"


COPY --from=build /usr/local /usr/local
COPY --from=build /etc/kea /etc/kea

RUN apt-get update && apt-get install -y --no-install-recommends libcap2-bin && \
    setcap cap_net_bind_service,cap_net_raw=+ep /usr/local/sbin/kea-dhcp4 && \
    setcap cap_net_bind_service=+ep /usr/local/sbin/kea-dhcp6 && \
    apt-get remove -y --autoremove --purge libcap2-bin && \
    rm -rf /var/lib/apt/* /var/cache/apt/*

RUN useradd -u 27489 -M kea && \
    mkdir /var/lib/kea /var/run/kea && chown kea:kea /var/lib/kea /var/run/kea

USER 27489

EXPOSE 67/udp

CMD ["/usr/local/sbin/kea-dhcp4", "-c", "/etc/kea/kea-dhcp4.conf"]
