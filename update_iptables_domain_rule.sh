#!/bin/bash
#
# Check if the iptables rule contains the actual current IP/domain of the needed host
#
# Edit DOMAIN field.


DOMAIN=
IPTABLES_DOMAIN=`iptables -L --line-numbers | grep 39999 | awk '{print $5}'`
IPTABLES_DOMAIN_N=`iptables -L --line-numbers | grep 39999 | awk '{print $1}'`
IP=`nslookup $DOMAIN | grep Address | tail -n 1 | awk '{print $2}'`
REV_IP=`nslookup ${IP} | grep name | awk '{print $4}'`
REV_IP=${REV_IP%.}

if [ $IPTABLES_DOMAIN == $REV_IP ]; then
	echo `date` "NOCHANGE iptables="$IPTABLES_DOMAIN "ip="$IP "reverse="$REV_IP >> /var/log/checkrules.log
else
	iptables -R INPUT $IPTABLES_DOMAIN_N -p tcp --dport 39999 -s bestrockers.ddns.net -j ACCEPT
	echo `date` "CHANGED iptables="$IPTABLES_DOMAIN "ip="$IP "reverse="$REV_IP >> /var/log/checkrules.log
fi
