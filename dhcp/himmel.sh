#!/bin/bash

# Set the nameserver IP address as a variable
nameserver_ip="192.168.122.1"
ip_dns="10.75.1.3"

# Update /etc/resolv.conf with the nameserver IP
echo -e "nameserver $ip_dns\nnameserver $nameserver_ip" > /etc/resolv.conf

# Install Bind9
apt-get update
apt-get install isc-dhcp-server -y

echo "INTERFACES='eth0'
" > /etc/default/isc-dhcp-server

echo "
# Switch 1
subnet 10.75.1.0 netmask 255.255.255.0 {
}

# Switch 2
subnet 10.75.2.0 netmask 255.255.255.0 {
}

# Switch 3
subnet 10.75.3.0 netmask 255.255.255.0 {
  range 10.75.3.16 10.75.3.32;
  range 10.75.3.64 10.75.3.80;
  option routers 10.75.3.0;
  option broadcast-address 10.75.3.255;
  option domain-name-servers 10.75.1.3; #DNS
  default-lease-time 180;
  max-lease-time 5760;
}

# Switch 4
subnet 10.75.4.0 netmask 255.255.255.0 {
  range 10.75.4.12 10.75.4.20;
  range 10.75.4.160 10.75.4.168;
  option routers 10.75.4.0;
  option broadcast-address 10.75.4.255;
  option domain-name-servers 10.75.1.3;
  default-lease-time 720;
  max-lease-time 5760;
}" > /etc/dhcp/dhcpd.conf

# Stop the DHCP server if it's running
service isc-dhcp-server stop

# Remove the PID file
rm /var/run/dhcpd.pid

# Restart the DHCP server
service isc-dhcp-server start

echo "The Greatest hero."