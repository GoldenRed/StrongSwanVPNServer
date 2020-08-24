#!/bin/bash
# Inspired by https://www.digitalocean.com/community/tutorials/how-to-set-up-an-ikev2-vpn-server-with-strongswan-on-ubuntu-20-04

serverdomain='insert domain'
serverip='insert server ip'
user='insert username'
pass='insert password'

# Installing Strongswan
apt update -y
apt install strongswan libcharon-extra-plugins -y

# Make sure to have copied this over from the VPN server
cp ca-cert.pem /etc/ipsec.d/cacerts/

# To prevent autostart of strongswan
systemctl disable --now strongswan-starter


# Create ipsec.secrets file
ipsecsecrets_contents='# This file holds shared secrets or RSA private keys for authentication.

# RSA private key for this host, authenticating it to any other host
# which knows the public part.

toreplaceuser : EAP "toreplacepass"'

ipsecsecrets_contents=${ipsecsecrets_contents//toreplaceuser/$user}
ipsecsecrets_contents=${ipsecsecrets_contents//toreplacepass/$pass}

echo "$ipsecsecrets_contents" > /etc/ipsec.secrets



# Edit ipsec.conf file

ipsecconf_contents="# basic configuration

config setup

conn ikev2-rw
    right=toreplaceip
    rightid=@toreplacedomain
    rightsubnet=0.0.0.0/0
    rightauth=pubkey
    leftsourceip=%config
    leftid=user
    leftauth=eap-mschapv2
    eap_identity=%identity
    auto=start
"

mv /etc/ipsec.conf{,.original}
ipsecconf_contents=${ipsecconf_contents//toreplaceip/$serverip}
ipsecconf_contents=${ipsecconf_contents//toreplacedomain/$serverdomain}
echo "$ipsecconf_contents" > /etc/ipsec.conf

# Test the IP:

echo "Current IP:"
curl https://ipinfo.io/ip

echo "Start VPN:"
systemctl start strongswan-starter.service

echo "New IP:"
curl https://ipinfo.io/ip