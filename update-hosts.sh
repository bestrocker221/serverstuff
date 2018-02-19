#!/bin/bash
#
# Check if the hosts file contains the actual current IP/domain of the needed host
#
# Edit DOMAIN field.
DOMAIN=
IP=`cat /etc/hosts | grep $DOMAIN | awk '{print $1}'`
NEW_IP=`nslookup $DOMAIN | grep Address | tail -n 1 | awk '{print $2}'`


if [ $IP == $NEW_IP ]; then
	echo `date` "NOCHANGE hosts="$DOMAIN "ip="$IP >> /var/log/checkrules.log
else
	sed -i -e "s/${IP}/${NEW_IP}/g" /etc/hosts
	echo `date` "CHANGED hosts="$DOMAIN "ip="$IP "newIP="$NEW_IP >> /var/log/checkrules.log
fi