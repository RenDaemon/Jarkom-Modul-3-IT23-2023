    #!/bin/bash

    # Set the nameserver IP address as a variable
    nameserver_ip="192.168.122.1"

    # Update /etc/resolv.conf with the nameserver IP
    echo "nameserver $nameserver_ip" > /etc/resolv.conf

    # Install Bind9
    apt-get update
    apt-get install bind9 -y

    mkdir /etc/bind/it23

    # Create the named.conf.local file
echo 'zone "riegel.canyon.it23.com" {
    type master;
    file "/etc/bind/it23/riegel.canyon.it23.com";
};

zone "granz.channel.it23.com" {
    type master;
    file "/etc/bind/it23/granz.channel.it23.com";
};

' > /etc/bind/named.conf.local

# DNS record for riegel.canyon
echo "\$TTL    604800
@       IN      SOA     riegel.canyon.it23.com. root.riegel.canyon.it23.com. (
                            2         ; Serial
                        604800        ; Refresh
                        86400         ; Retry
                        2419200       ; Expire
                        604800 )      ; Negative Cache TTL
;
@       IN      NS      riegel.canyon.it23.com.
@       IN      A       10.75.2.3 ;4.1/2.3(Eisen)
www     IN      CNAME   riegel.canyon.it23.com." > /etc/bind/it23/riegel.canyon.it23.com


# DNS record for granz.channel
echo "\$TTL    604800
@          IN      SOA  granz.channel.it23.com. root.granz.channel.it23.com. (
                            2         ; Serial
                        604800        ; Refresh
                        86400         ; Retry
                        2419200       ; Expire
                        604800 )      ; Negative Cache TTL
;
@          IN     NS      granz.channel.it23.com.
@          IN     A       10.75.2.3 ;3.1/2.3 (Eisen)
www        IN     CNAME   granz.channel.it23.com." > /etc/bind/it23/granz.channel.it23.com

# Restart Bind9
    service bind9 restart

    echo "Corrupt Priest."