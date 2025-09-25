# parse arguments, set KEA_CONFIG based on requested service

if [ "$#" -eq 0 ]; then
    echo "[-] No argument found. Specify one exactly, or use /dhcp4 or /dhcp6."
    echo ""
    echo "See https://github.com/kubernetize/kea/blob/main/README.md"
    exit 1
fi

case "$1" in
    /dhcp4)
        set -- /usr/sbin/kea-dhcp4 -c "${KEA_CONFIG:=/etc/kea/kea-dhcp4.conf}"
        export KEA_CONFIG
        ;;
    /dhcp6)
        set -- /usr/sbin/kea-dhcp6 -c "${KEA_CONFIG:=/etc/kea/kea-dhcp6.conf}"
        export KEA_CONFIG
        ;;
esac
