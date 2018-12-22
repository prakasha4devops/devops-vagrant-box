#!/bin/bash

# php installatipon
apt-get update -y  && apt-get upgrade -y;

apt-get install -y  software-properties-common;

add-apt-repository -y ppa:ondrej/php;

apt-get update -y;

apt-get install -y php7.3;

apt-get install -y php-pear php7.3-curl php7.3-dev php7.3-gd php7.3-mbstring php7.3-zip php7.3-mysql php7.3-xml php7.3-cli php7.3-gmp;

update-alternatives --set php /usr/bin/php7.3;

php --ini;

a2enmod php7.3;

systemctl restart apache2;

# composer installation
curl -sS https://getcomposer.org/installer -o composer-setup.php;

php composer-setup.php --install-dir=/usr/local/bin --filename=composer;

# apache2 installation

apt-get install -y apache2;
systemctl restart apache2;
ufw allow in "Apache Full";

# mysql installation

apt-get install -y mysql-server;
