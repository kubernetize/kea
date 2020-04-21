FROM alpine:3.11

LABEL maintainer="Richard Kojedzinszky"

RUN adduser -u 27489 -D -H kea && \
    apk --no-cache add kea-admin kea-dhcp4 && \
    mkdir /run/kea && chown kea:kea /run/kea && \
    # fix kea installation
    ln -s kea/scripts /usr/share/kea/scripts

USER 27489

EXPOSE 1667/udp

CMD ["/usr/sbin/kea-dhcp4", "-c", "/etc/kea/kea-dhcp4.conf", "-p", "1667"]
