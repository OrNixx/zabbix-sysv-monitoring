#!/bin/bash

service_list=`chkconfig --list --type sysv | awk '{print $1}'`

[[ -r /etc/zabbix/service_discovery_whitelist ]] && {
    service_list=$(echo "$service_list" | grep -w -E -f /etc/zabbix/service_discovery_whitelist)
}

[[ -r /etc/zabbix/service_discovery_blacklist ]] && {
    service_list=$(echo "$service_list" | grep -Evw -f /etc/zabbix/service_discovery_blacklist)
}

echo -n '{"data":[';for s in ${service_list}; do echo -n "{\"{#SERVICE}\": \"$s\"},";done | sed -e 's:\},$:\}:';echo -n ']}'
