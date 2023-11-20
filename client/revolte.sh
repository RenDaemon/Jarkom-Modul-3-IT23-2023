# Set the nameserver IP address as a variable
nameserver_ip="192.168.122.1"
ip_dns="10.75.1.3"
ip_lb="10.75.2.3"

# Update /etc/resolv.conf with the nameserver IP
echo -e "nameserver $ip_dns\nnameserver $ip_lb" > /etc/resolv.conf

#Installation-Utils
apt update
apt install lynx -y
apt install htop -y
apt install apache2-utils -y
apt-get install jq -y