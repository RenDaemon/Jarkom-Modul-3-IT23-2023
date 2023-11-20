iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.75.0.0/16

# Set the nameserver IP address as a variable
nameserver_ip="192.168.122.1"
ip_dns="10.75.1.3"

# Update /etc/resolv.conf with the nameserver IP
echo -e "nameserver $ip_dns\nnameserver $nameserver_ip" > /etc/resolv.conf

# Install ISC DHCP relay
apt-get update
apt-get install isc-dhcp-relay -y

#assign IP address to all switch
echo "SERVERS='10.75.1.2'
INTERFACES='eth1 eth2 eth3 eth4'
OPTIONS=''" > /etc/default/isc-dhcp-relay

# Enable IP forwarding
echo "net.ipv4.ip_forward=1" > /etc/sysctl.conf
sysctl -p

# Restart DHCP relay service
service isc-dhcp-relay restart

echo "Aura the Guillotine."
