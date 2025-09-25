# kea

Rootless Kea from Alpine with `CAP_NET_BIND_SERVICE` set on binary.

## Startup

The image has no default command set, you must specify one. Either use `/dhcp4` or `/dhcp6`, or set one explicitly. During startup, the container will do a KEA database migration, reading SQL connection parameters from KEA configuration file's `hosts-database` section. The migration process requires `KEA_CONFIG` environment variable to be set. Howewer, with the two special arguments, `KEA_CONFIG` will get a default value, and the relevant command will be run:

arg | KEA_CONFIG default value | Final command
-|-|-
/dhcp4 | /etc/kea/kea-dhcp4.conf | /usr/sbin/kea-dhcp4 -c "${KEA_CONFIG}"
/dhcp6 | /etc/kea/kea-dhcp6.conf | /usr/sbin/kea-dhcp6 -c "${KEA_CONFIG}"
