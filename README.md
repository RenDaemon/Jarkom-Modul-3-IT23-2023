# Jarkom-Modul-3-IT23-2023
**Praktikum Jaringan Komputer Modul 3**

## Author
| Nama | NRP |
|---------------------------|------------|
|Rendy Anfi Yudha| 5027211006 |
|Dhea Arfryza Ananda P. | 5027211013 |

# Laporan Resmi
## Daftar Isi
- [Topologi](#topologi)
- [Soal 0](#soal-0)
- [Soal 1](#soal-1)
- [Soal 2](#soal-2)
- [Soal 3](#soal-3)
- [Soal 4](#soal-4)
- [Soal 5](#soal-5)
- [Soal 6](#soal-6)
- [Soal 7](#soal-7)
- [Soal 8](#soal-8)
- [Soal 9](#soal-9)
- [Soal 10](#soal-10)
- [Soal 11](#soal-11)
- [Soal 12](#soal-12)
- [Soal 13](#soal-13)
- [Soal 14](#soal-14)
- [Soal 15](#soal-15)
- [Soal 16](#soal-16)
- [Soal 17](#soal-17)
- [Soal 18](#soal-18)
- [Soal 19](#soal-19)
- [Soal 20](#soal-20)

### Pre-requisites
#### Topologi
Buatlah topologi sesuai dengan yang tertera di soal seperti gambar berikut :
![topologi](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/94961661/d1793e87-6db1-46b6-b328-80451301ee9b) 

#### Konfigurasi Network :
- **Aura (DHCP Relay & Router)**
```
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
	address 10.75.1.1
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 10.75.2.1
	netmask 255.255.255.0

auto eth3
iface eth3 inet static
	address 10.75.3.0
	netmask 255.255.255.0

auto eth4
iface eth4 inet static
	address 10.75.4.0
	netmask 255.255.255.0

```
- **Himmel (DHCP Server)**
```
auto eth0
iface eth0 inet static
	address 10.75.1.2
	netmask 255.255.255.0
	gateway 10.75.1.1

```
- **Heiter (DNS Server)**
```
auto eth0
iface eth0 inet static
	address 10.75.1.3
	netmask 255.255.255.0
	gateway 10.75.1.1
```
- **Denken (Database Server)**
```
auto eth0
iface eth0 inet static
	address 10.75.2.2
	netmask 255.255.255.0
	gateway 10.75.2.1
```
- **Eisen (Load Balancer)**
```
auto eth0
iface eth0 inet static
	address 10.75.2.3
	netmask 255.255.255.0
	gateway 10.75.2.1
```
- **Frieren (Laravel Worker)**
```
auto eth0
iface eth0 inet static
	address 10.75.4.1
	netmask 255.255.255.0
	gateway 10.75.4.0

```
- **Flamme (Laravel Worker)**
```
auto eth0
iface eth0 inet static
	address 10.75.4.2
	netmask 255.255.255.0
	gateway 10.75.4.0

```
- **Fern (Laravel Worker)**
```
auto eth0
iface eth0 inet static
	address 10.75.4.3
	netmask 255.255.255.0
	gateway 10.75.4.0

```
- **Lawine (PHP Worker)**
```
auto eth0
iface eth0 inet static
	address 10.75.3.1
	netmask 255.255.255.0
	gateway 10.75.3.0

```
- **Linie (PHP Worker)**
```
auto eth0
iface eth0 inet static
	address 10.75.3.2
	netmask 255.255.255.0
	gateway 10.75.3.0

```
- **Lugner (PHP Worker)**
```
auto eth0
iface eth0 inet static
	address 10.75.3.3
	netmask 255.255.255.0
	gateway 10.75.3.0

```
- **Sein, dan Stark, Revolte, dan Richter (Clients)**
```
auto eth0
iface eth0 inet dhcp
```

### Soal 0
#### Descrription :
Diminta untuk melakukan register domain berupa riegel.canyon.yyy.com untuk worker Laravel dan granz.channel.yyy.com untuk worker PHP

#### PoC :
Disini kita hanya perlu melakukan register 2 domain tersebut ke worker php yang memiliki prefik ip [prefix IP].x.1

#### Installing 
```sh
    # Install Bind9
    apt-get update
    apt-get install bind9 -y

    mkdir /etc/bind/it23
``` 

#### Zoning
```sh
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
```

#### DNS Record
```sh
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
@       IN      A       10.75.4.1
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
@          IN     A       10.75.3.1
www        IN     CNAME   granz.channel.it23.com." > /etc/bind/it23/granz.channel.it23.com
```
Setelah semua konfigurasi tersebut selesai tinggal restart nginx dan DNS server sudah menyala. Setup selengkapnya dapat dilihat di ![Heiter](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/blob/main/dns/heiter.sh)

### Soal 1
#### Description :
Semua CLIENT harus menggunakan konfigurasi dari DHCP Server.

#### PoC :
Karena semua network client bersifat dinamis menggunakan dhcp, kita harus melakukan setup dhcp server terlebih dahulu

## Berikut ketentuan setup untuk dhcp server :
### Soal 2
#### Description :
Client yang melalui Switch3 mendapatkan range IP dari [prefix IP].3.16 - [prefix IP].3.32 dan [prefix IP].3.64 - [prefix IP].3.80

```sh
subnet 10.75.3.0 netmask 255.255.255.0 {
  range 10.75.3.16 10.75.3.32;
...
```

### Soal 3
#### Description :
Client yang melalui Switch4 mendapatkan range IP dari [prefix IP].4.12 - [prefix IP].4.20 dan [prefix IP].4.160 - [prefix IP].4.168 

```sh
subnet 10.75.4.0 netmask 255.255.255.0 {
  range 10.75.4.12 10.75.4.20;
  ...
```
### Soal 4
#### Description :
Client mendapatkan DNS dari Heiter dan dapat terhubung dengan internet melalui DNS tersebut. Jika setup dhcp server dan relay sudah valid maka harusnya saat menghubungkan ke client akan secara otomatis akan mendapatkan ip sesuai yang diatur dan nameserver mendapatkan nameserver dns server (Heiter)

### Soal 5
#### Description :
Lama waktu DHCP server meminjamkan alamat IP kepada Client yang melalui Switch3 selama 3 menit sedangkan pada client yang melalui Switch4 selama 12 menit. Dengan waktu maksimal dialokasikan untuk peminjaman alamat IP selama 96 menit.

- Switch 3
```sh
...
  default-lease-time 180; # 3 menit
  max-lease-time 5760; # 96 menit
}
```

- Switch 4
```sh
  default-lease-time 720; # 12 menit
  max-lease-time 5760; # 96 menit
}
```
#### Testing Client
Langkah pertama yang harus dilakukan setlah melakukan semua setup adalah menjalankan ketiga service terlebih dahulu yaitu :
- DNS server ![Heiter](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/blob/main/dns/heiter.sh)
- DHCP server ![Himmel](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/blob/main/dhcp/himmel.sh)
- DHCP relay ![Aura](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/blob/main/router/aura.sh)

##### Start DNS, DHCP, Relay
![init](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/94961661/9cb59615-c1b2-49a2-a151-af6736ed3061)

##### Connect client stark
![client](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/94961661/b55cc877-8843-44dc-bdac-7153e8aba33c)

Coba hubungkan ke salah satu client, jika konfigurasi sudah berhasil harusnya di setiap client mendapatkan ip sesuai dengan range yang telah kita set di dhcp server.

###### ping google.com || 8.8.8.8
![google](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/94961661/0e7f8626-ab8c-4056-a6d1-3a41b5bed241)

###### ping domain name
![domain](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/94961661/9f2b6cb8-bfba-4151-86c4-a5b704afc9a9)


### Soal 6
#### Description :
Pada masing-masing worker PHP, lakukan konfigurasi virtual host untuk website berikut dengan menggunakan php 7.3

#### Instalasi
Pada setiap worker php lakukan beberpa instalasi sebagai berikut :
```sh
#Utils Installation
apt-get update
apt-get install nginx -y
apt-get install wget -y
apt-get install unzip -y
apt-get install lynx -y
apt-get install htop -y
apt-get install apache2-utils -y
apt-get install php7.3-fpm php7.3-common php7.3-mysql php7.3-gmp php7.3-curl php7.3-intl php7.3-mbstring php7.3-xmlrpc php7.3-gd php7.3-xml php7.3-cli php7.3-zip -y
```
Kemudian download attachmet yang diperlukan!
```sh
#Attachments
wget -O '/var/www/granz.channel.it23.com' 'https://drive.google.com/u/0/uc?id=1ViSkRq7SmwZgdK64eRbr5Fm1EGCTPrU1&export=download'
unzip -o /var/www/granz.channel.it23.com -d /var/www/
rm /var/www/granz.channel.it23.com
mv /var/www/modul-3 /var/www/granz.channel.it23.com
```

Nginx Config
```sh
cp /etc/nginx/sites-available/default /etc/nginx/sites-available/granz.channel.it23.com
ln -s /etc/nginx/sites-available/granz.channel.it23.com /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default
```
```sh
echo 'server {
    listen 80;
    server_name _;

    root /var/www/granz.channel.it23.com;
    index index.php index.html index.htm;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.3-fpm.sock;  # Sesuaikan versi PHP dan socket
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}' > /etc/nginx/sites-available/granz.channel.it23.com
```
Kemudian tinggal restart server nginx.

Jangan lupa setup config load balancer
```sh
echo 'upstream worker 
    server 10.75.3.1;
    server 10.75.3.2;
    server 10.75.3.3;
}

server {
    listen 80;
    server_name granz.channel.it23.com www.granz.channel.it23.com;

    root /var/www/html;

    index index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {

        proxy_pass http://worker;
    }
} ' > /etc/nginx/sites-available/lb_php

ln -s /etc/nginx/sites-available/lb_php /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

service nginx restart
```
Untuk script setup selengkapnya dapat dilihat di ![eisen](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/blob/main/load-balancer/eisen.sh)

Kemudian untuk testing gunakan command `lynx http://10.75.2.3/`, jika semua setup sudah valid dan sudah terdeploy maka outputnya akan menjadi seperti berikut
![testphp](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/94961661/b2c819ae-14db-44e4-9864-ae040fa0792b)

### Soal 7
#### Description :
Aturlah agar Eisen dapat bekerja dengan maksimal, lalu lakukan testing dengan 1000 request dan 100 request/second.

Untuk testing pada poin ini kita gunakan command `ab -n 1000 -c 100 http://10.75.2.3/`. Outputnya akan berupa benchmark dari 1000 request dengan 100 req/s
![benchmark](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/94961661/992f9802-ee3a-47f3-98e8-9e106b79bfa8)

### Soal 8
#### Description :
Buatlah analisis hasil testing dengan 200 request dan 10 request/second masing-masing algoritma Load Balancer.

#### PoC :
Pada poin ke 8 ini kita diminta untuk melakukan perbandingan antar algoritma load balancer berdasakan request per second.

Tambahkan config berikut pada eisen
```sh
echo 'upstream worker {
    # least_conn;
    # ip_hash;
    # hash $request_uri consistent;
    server 10.75.3.1;
    server 10.75.3.2;
    server 10.75.3.3;
}
```
Secara default kita sebelumnya menggunakan algoritma load balancer, untuk menggantinya tinggal uncomment salah satu algoritma yg sudah dijalankan dan lakukan benchmarking ulang
dengan command `ab -n 200 -c 10 http://10.75.2.3/`

Hasilnya kurang lebih sama ketika dijalankan, karena kita diminta untuk menganalisis perbandingan request per second maka dibuat grafik :
![graphLoadbalancer](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/94961661/63288bcd-a958-473d-a918-da0f5ac73df9)

### Soal 9
#### Description :
Dengan menggunakan algoritma Round Robin, lakukan testing dengan menggunakan 3 worker, 2 worker, dan 1 worker sebanyak 100 request dengan 10 request/second, kemudian tambahkan grafiknya pada grimoire

#### PoC :
Hampir mirip seperti poin sebelumnya, namun kali ini kita testing menggunakan algoritma round robbin dengan perbandingan jumlah worker

Edit config upstream berikut pada eisen
```sh
echo 'upstream worker {
    server 10.75.3.1;
    server 10.75.3.2;
    server 10.75.3.3;
}
```
Untuk mengubah" jumlah worker tinggal comment salah satu daritiga server tersebut dan jalankan secara bertahap, menggunakan command `ab -n 100 -c 10 http://10.75.2.3/ `  
Berikut hasil grafik grimoirenya :
![graphWorker](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/94961661/f0612461-8395-4788-825d-245bdbacac07)

Untuk penjelasan detail tentang grafik di grimoire bisa diakses pada link berikut : https://its.id/m/IT23_Grimoire

### Soal 10
#### Description :
tambahkan konfigurasi autentikasi di LB dengan dengan kombinasi username: “netics” dan password: “ajkyyy”, dengan yyy merupakan kode kelompok. Terakhir simpan file “htpasswd” nya di /etc/nginx/rahasisakita/

#### PoC :
Pada poin ke-10 ini kita diminta untuk menambahkan proses authentikasi pada load balancer eisen. 

Tambahkan config berikut:
```sh
# Creating a directory for htpasswd file
mkdir -p /etc/nginx/rahasisakita

# Creating an htpasswd file and adding a user
htpasswd -b -c /etc/nginx/rahasisakita/htpasswd netics ajkit23

location /{

...
    # Adding basic authentication
    auth_basic "Restricted Content";
    auth_basic_user_file /etc/nginx/rahasisakita/htpasswd;
...    
}
```
Config selengkapnya dapat diakses di ![eisen](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/blob/main/load-balancer/eisen.sh)

Untuk testing ketika kita akses `lynx http://10.75.2.3/`, harusnya perlu untuk memasukkan username:password yang sudah kita setup untuk akses

![username](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/94961661/0bef5660-f557-43b4-923c-b21dc916b53d)
![password](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/94961661/6582e6ba-024a-4db2-b330-aa345c51cb94)

### Soal 11
#### Description :
Lalu buat untuk setiap request yang mengandung /its akan di proxy passing menuju halaman https://www.its.ac.id. (11) hint: (proxy_pass)

#### PoC :
Untuk poin 11 kita diminta forward request ke https://www.its.ac.id jika mengandung /its

Tambahkan location baru di config seperti berikut:
```sh
    location ~ /its {
        proxy_pass https://www.its.ac.id;
        proxy_set_header Host www.its.ac.id;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
```
Jika setup config sudah valid maka setiap request ke /its akan diarahkan ke www.its.ac.id. Coba hubungkan dengan menggunakan `lynx http://10.75.2.3/its`
Maka tampilannya akan berubah menjadi seperti ini :
![its](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/94961661/fb44b2c8-9939-438d-a5c1-4a28b5988dd9)

### Soal 12
#### Description :
Selanjutnya LB ini hanya boleh diakses oleh client dengan IP [Prefix IP].3.69, [Prefix IP].3.70, [Prefix IP].4.167, dan [Prefix IP].4.168

#### PoC :
Untuk poin 12 kita diminta untuk mebatasi akses ke website hanya untuk beberapa ip saja. 

Tambahkan config sebgai berikut :
```sh
    location / {

        allow 10.75.3.69;
        allow 10.75.3.70;
        allow 10.75.3.19;
        allow 10.75.4.167;
        allow 10.75.4.168;
        # allow [ur ip here];
        deny all;
```
Selain IP yang sudah dicantumkan diatas harusnya tidak bisa mengakses website dengan status 302 Forbidden seperti ini
![forbiden](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/94961661/73bdfa22-916e-4502-b99a-d87fa2369736)
Agar kembali ke tampilan semula, tinggal kita tambahkan ip yg kita dapatkan di client di config tersebut `# allow [ur ip here]`
Setelah itu tampilan akan kembali lagi ke tampilan semula
![testphp](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/94961661/b2c819ae-14db-44e4-9864-ae040fa0792b)

### Soal 13
#### Description :
Semua data yang diperlukan, diatur pada Denken dan harus dapat diakses oleh Frieren, Flamme, dan Fern.

#### PoC :
Karena perlu mengatur config pada Denken, berikut untuk konfigurasi yang diperlukan:

#### Installing
```bash
apt-get update
apt-get install mariadb-server -y
service mysql start
```
#### Denken
```bash
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
```

Pada /etc/mysql/my.cnf :
```bash
echo '
[client-server]

# Import all .cnf files from configuration directory
!includedir /etc/mysql/conf.d/
!includedir /etc/mysql/mariadb.conf.d/

[mysqld]
skip-networking=0
skip-bind-address' > /etc/mysql/my.cnf

service mysql restart
```

## Output :
![Cuplikan layar 2023-11-20 114536](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/89828723/34b22820-e8ed-41c0-b448-23080e601b43)

Lalu melakukan konfigurasi pada 3 Worker Laravel
#### FFF
```bash
apt-get update
apt install lynx -y
apt-get install mariadb-client -y
```

Jalankan ```mariadb --host=10.75.2.2 --port=3306 --user=kelompokit23 --password```
![Cuplikan layar 2023-11-20 115151](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/89828723/43a09af7-6498-43f9-84c2-450b149df197)


### Soal 14
#### Description :
Frieren, Flamme, dan Fern memiliki Riegel Channel sesuai dengan quest guide berikut. Jangan lupa melakukan instalasi PHP8.0 dan Compose

#### PoC :
Karena perlu melakukan instalasi, perlu menambahkan beberapa konfigurasi dan instalasi pada 3 Laravel Worker

#### Frieren
```bash
apt-get update
apt install -y lsb-release apt-transport-https ca-certificates wget

# Add Sury.org repository key
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg

# Add Sury.org repository to sources.list
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/$
# Update apt cache again
apt-get update

# Install PHP 7.3 and required extensions
apt install -y php8.0 php8.0-mbstring php8.0-xml php8.0-cli php8.0-common php$
apt-get install nginx -y

wget https://getcomposer.org/download/2.0.13/composer.phar
chmod +x composer.phar
mv composer.phar /usr/bin/composer

apt-get install git -y

cd /var/www
git clone https://github.com/martuafernando/laravel-praktikum-jarkom.git
cd /var/www/laravel-praktikum-jarkom
cp .env.example .env

```
Masuk ke dalam .env
```nano .env``` Ganti dibagian config tertentu menjadi:
```bash
DB_CONNECTION=mysql
DB_HOST=10.75.2.2
DB_PORT=3306
DB_DATABASE=dbkelompokit23
DB_USERNAME=kelompokit23
DB_PASSWORD=passwordit23
```

Run ```composer update```
Setelah composer berhasil di install, run php artisan:
```
php artisan migrate:fresh
php artisan db:seed --class=AiringsTableSeeder
php artisan key:generate
php artisan config:cache
php artisan migrate
php artisan db:seed
php artisan storage:link
php artisan jwt:secret
php artisan config:clear
```
```chown -R www-data.www-data /var/www/laravel-praktikum-jarkom/storage```

Lalu melakukan konfigurasi nginx pada ```nano /etc/nginx/sites-available/deploy```

```
server {

    listen 8001;

    root /var/www/laravel-praktikum-jarkom/public;

    index index.php index.html index.htm;
    server_name _;

    location / {
            try_files $uri $uri/ /index.php?$query_string;
    }

    # pass PHP scripts to FastCGI server
    location ~ \.php$ {
    include snippets/fastcgi-php.conf;
    fastcgi_pass unix:/var/run/php/php8.0-fpm.sock;
    }

location ~ /\.ht {
            deny all;
    }

    error_log /var/log/nginx/deploy_error.log;
    access_log /var/log/nginx/deploy_access.log;
}

```
Pada ```listen 8001``` diisi sesuai port di tiap worker.

Selanjutnya melakukan testing melalui ```lynx localhost:port```

Melakukan hal yang sama dengan ke-worker
```
10.75.4.1:8001 ; Frieren
10.75.4.2:8002 ; Flamme
10.75.4.1:8003 ; Fern
```

```lynx localhost:8001```

![Picture1](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/89828723/923f672d-f9a1-4d9e-b3ee-1a159ea3520a)

### Soal 15
#### Description :
Riegel Channel memiliki beberapa endpoint yang harus ditesting sebanyak 100 request dengan 10 request/second.  

#### PoC :
a. POST /auth/register

Masukkan config ke ```nano register.json```
```
{
  "username": "kelompokit23",
  "password": "passwordit23"
}
```

Lalu, run ```ab -n 100 -c 10 -p register.json -T application/json http://10.75.4.1:8001/api/auth/register``` pada Client

## Output :

![Picture2](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/89828723/9c7a8e10-0fa0-45ec-925b-64f18e7a756c)

### Soal 16
#### Description :
Riegel Channel memiliki beberapa endpoint yang harus ditesting sebanyak 100 request dengan 10 request/second.  

#### PoC :
b. POST /auth/login

Masukkan config ke ```nano login.json```
```
{
  "username": "kelompokit23",
  "password": "passwordit23"
}
```

Lalu, run ```ab -n 100 -c 10 -p login.json -T application/json http://10.75.4.1:8001/api/auth/login``` pada Client

## Output:

![Picture3](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/89828723/3f1bba3a-80ed-4460-8cdd-1e49c20a6006)

### Soal 17
#### Description :
Riegel Channel memiliki beberapa endpoint yang harus ditesting sebanyak 100 request dengan 10 request/second.  

#### PoC :
c. GET /me
Pada Client, jalankan command

```
curl -X POST -H "Content-Type: application/json" -d @login.json http://10.75.4.1:8001/api/auth/login > login_output.txt

token=$(cat login_output.txt | jq -r '.token')/me

ab -n 100 -c 10 -H "Authorization: Bearer $token" http://10.75.4.1:8001/api/me
```

Output:

![Picture4](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/89828723/1d0e2708-3a47-46b1-8598-d4213ff1267c)

### Soal 18
#### Description :
Untuk memastikan ketiganya bekerja sama secara adil untuk mengatur Riegel Channel maka **implementasikan Proxy Bind pada Eisen** untuk mengaitkan IP dari Frieren, Flamme, dan Fern

#### PoC :
Karena memerlukan implementasi Proxy Bind pada Eisen, maka lakukan config pada ```nano /etc/nginx/sites-available/worker-fff```
```bash
upstream worker {
    server 10.75.4.1:8001;
    server 10.75.4.2:8002;
    server 10.75.4.3:8003;
}

server {
    listen 80;
    server_name riegel.canyon.it23.com;

    location / {
        proxy_pass http://worker;
    }
}
```

Lalu, pada **Heiter** Ganti IP di Bind sebelumnya menjadi IP EISEN
```bash
echo ";
; BIND data file for local loopback interface
;
\$TTL    604800
@       IN      SOA     riegel.canyon.it23.com. root.riegel.canyon.it23.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@           IN      NS      riegel.canyon.it23.com.
@           IN      A       10.75.2.3 ; IP EISEN
www         IN      CNAME   riegel.canyon.it23.com.
" >/etc/bind/zones/riegel.canyon.it23.com
```

Pada Client **Revolte**
Jalankan command

```ab -n 100 -c 10 -p login.json -T application/json http://riegel.canyon.it23.com/api/auth/login```

## Output:

![Picture5](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/89828723/aae501cb-bcd4-4fcc-ad48-38fccd80383e)


Pada FFF Worker
mengecek log pada ```cat /var/log/nginx/deploy_access.log```

## Output:

#### Frieren
![Picture6](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/89828723/db2a119b-c82e-48f2-b3a6-fb1e83c38a9d)

#### Frieren
![Picture7](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/89828723/0b9b2b16-f6d2-4b03-b878-24f1af13e347)

#### Fern
![Picture8](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/89828723/2696a00d-40db-4e31-8680-d05fbdc3cb75)

### Soal 19
#### Description :
Untuk meningkatkan performa dari Worker, coba implementasikan PHP-FPM pada Frieren, Flamme, dan Fern. Untuk testing kinerja naikkan 
- pm.max_children
- pm.start_servers
- pm.min_spare_servers
- pm.max_spare_servers
sebanyak tiga percobaan dan lakukan testing sebanyak 100 request dengan 10 request/second

#### PoC :
Implementasikan PHP-FPM pada 3 Laravel Worker

**Frieren**

Menerapkan ke 3 percobaan dengan config :
#### test1.sh 
```bash
#!/bin/bash
echo '[www]
user = www-data
group = www-data
listen = /run/php/php8.0-fpm.sock
listen.owner = www-data
listen.group = www-data
php_admin_value[disable_functions] = exec,passthru,shell_exec,system
php_admin_flag[allow_url_fopen] = off

; Choose how the process manager will control the number of child processes.

pm = dynamic
pm.max_children = 3
pm.start_servers = 4
pm.min_spare_servers = 2
pm.max_spare_servers = 5' > /etc/php/8.0/fpm/pool.d/www.conf

service php8.2-fpm restart
```
#### test2.sh
```bash
echo '[www]
user = www-data
group = www-data
listen = /run/php/php8.0-fpm.sock
listen.owner = www-data
listen.group = www-data
php_admin_value[disable_functions] = exec,passthru,shell_exec,system
php_admin_flag[allow_url_fopen] = off

; Choose how the process manager will control the number of child processes.

pm = dynamic
pm.max_children = 6
pm.start_servers = 5
pm.min_spare_servers = 3
pm.max_spare_servers = 10' > /etc/php/8.0/fpm/pool.d/www.conf

service php8.2-fpm restart
```

#### test3.sh
```bash
echo '[www]
user = www-data
group = www-data
listen = /run/php/php8.0-fpm.sock
listen.owner = www-data
listen.group = www-data
php_admin_value[disable_functions] = exec,passthru,shell_exec,system
php_admin_flag[allow_url_fopen] = off

; Choose how the process manager will control the number of child processes.

pm = dynamic
pm.max_children = 9
pm.start_servers = 6
pm.min_spare_servers = 4
pm.max_spare_servers = 11' > /etc/php/8.0/fpm/pool.d/www.conf

service php8.2-fpm restart
```

## Output:
#### test1.sh
![Picture9](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/89828723/bf5fd774-7d12-4943-9e7d-48eb3d507ea0)

#### test2.sh
![Picture10](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/89828723/c8560b90-76a0-42ab-b34f-3ca9e3e7c648)

#### test3.sh
![Picture11](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/89828723/f543a64d-ce85-41a7-8efa-423ce1b81fa3)


### Soal 20
#### Description :
Nampaknya hanya menggunakan PHP-FPM tidak cukup untuk meningkatkan performa dari worker maka implementasikan Least-Conn pada Eisen. Untuk testing kinerja dari worker tersebut dilakukan sebanyak 100 request dengan 10 request/second. 

#### PoC :
Implementasikan **Least-Conn** pada Eisen :
```bash
echo '
upstream worker {
    least_conn;
    server 10.75.4.1:8001;
    server 10.75.4.2:8002;
    server 10.75.4.3:8003;
}
```

## Output:

![Picture12](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/89828723/66ecf397-b328-4cbf-83fc-904792d45eeb)

