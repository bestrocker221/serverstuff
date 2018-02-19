#!/bin/sh
#
# My server iptables rules.
# Launch  ./firewall_rules
#

# Flushing all existing rules
iptables -t nat -F
iptables -F

#
# INPUT CHAIN
#

# Permit localhost network
iptables -A INPUT -i lo -j ACCEPT
# Permit current inbound related/established connections
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

#permit SSH traffic on port 22
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

#permit Web server 80/443
iptables -A INPUT -p tcp -m multiport --dports 80,443 -j ACCEPT

#permit Postfix/Dovecot on port 25,993,587
iptables -A INPUT -p tcp -m multiport --dports 25,587,993 -j ACCEPT

#allow icmp echo-reply to server
iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

#
# OUTPUT CHAIN
# 

# Permit outbound connection from localhost
iptables -A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

#allow server to connect to other's server's port 80
iptables -A OUTPUT -p tcp -m multiport --dports 80,443 -j ACCEPT

#permit DNS protocol on port 53
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT

#accept inbound smtp (25) connection to other mail server
iptables -A OUTPUT -p tcp --dport 25 -j ACCEPT

#allow icmp request from server
iptables -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT


#allow only smtp ssl traffic
iptables -I OUTPUT -p tcp --dport 465 -j ACCEPT

#Log dropped packets
iptables -N LOGGING
iptables -A INPUT -j LOGGING
iptables -A OUTPUT -j LOGGING
iptables -A LOGGING -j LOG --log-prefix "iptables dropped: " --log-level 7

#default policy
iptables -P FORWARD DROP
iptables -P INPUT DROP
iptables -P OUTPUT DROP
