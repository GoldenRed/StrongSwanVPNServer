# StrongSwan Server Executables

This directory contains scripts and files to set up StrongSwan automatically.

# Instructions
1. Replace the serverdomain, serverip (on client), user and pass variables in the scripts. Insert your own values.
2. Run `sudo setup-script-server.sh` on your server instance (after `chmod +x setup-script-server.sh`). As its final step it will put the ca-cert.pem in your pwd. Download it.
3. Put the ca-cert.pem file on your client instance before running `sudo setup-script-client.sh` (after `chmod +x setup-script-client.sh`). 
4. The script should activate the strongswan software itself as part of `systemctl start strongswan-starter.service`.

# NOTES
- If you wish to use a raw IP adress instead of a domain remove the @-symbol in the leftid field in /etc/ipsec.conf

# CREDITS
This repo is based off of: https://www.digitalocean.com/community/tutorials/how-to-set-up-an-ikev2-vpn-server-with-strongswan-on-ubuntu-20-04
