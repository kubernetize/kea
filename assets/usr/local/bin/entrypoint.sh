#!/bin/sh

r=5
while ! kea-db-init-upgrade ; do
	if [ $r -eq 0 ]; then
		echo "[-] kea-db-init-upgrade retries exhausted, exiting"
		exit 1
	fi
	r=$((r-1))
	sleep 1
done

exec "$@"
