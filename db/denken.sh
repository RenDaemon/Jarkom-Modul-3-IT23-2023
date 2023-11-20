echo 'nameserver 192.168.122.1' > /etc/resolv.conf

apt-get update
apt-get install mariadb-server -y
service mysql start

# Nomer 13
mysql <<EOF
CREATE USER 'kelompokit23'@'%' IDENTIFIED BY 'passwordit23';
CREATE USER 'kelompokit23'@'localhost' IDENTIFIED BY 'passwordit23';
CREATE DATABASE dbkelompokit23;
GRANT ALL PRIVILEGES ON *.* TO 'kelompokit23'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'kelompokit23'@'localhost';
FLUSH PRIVILEGES;
quit
EOF

# Log in to MySQL with the specified user and password
mysql -u kelompokit23 -p'passwordit23' <<EOF
SHOW DATABASES;
quit
EOF

echo '
[client-server]

# Import all .cnf files from configuration directory
!includedir /etc/mysql/conf.d/
!includedir /etc/mysql/mariadb.conf.d/

[mysqld]
skip-networking=0
skip-bind-address' > /etc/mysql/my.cnf

service mysql restart