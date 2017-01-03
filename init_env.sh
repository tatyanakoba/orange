#!/usr/bin/env bash

apt-get install -y apache2 git curl php5-cli php5 php5-intl libapache2-mod-php5 php5-xdebug

debconf-set-selections <<< "mysql-server mysql-server/root_password password 369"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password 369"
sudo apt-get -y install mysql-server
sudo apt-get install php5-mysql

DOCUMENT_ROOT_ZEND="/var/www/orange/public"
echo "
<VirtualHost *:80>
    ServerName orange.local
    DocumentRoot $DOCUMENT_ROOT_ZEND
    <Directory $DOCUMENT_ROOT_ZEND>
        DirectoryIndex index.php
        AllowOverride All
        Order allow,deny
        Allow from all
    </Directory>
</VirtualHost>
" > /etc/apache2/sites-available/orange.local.conf
a2enmod rewrite
cd /etc/apache2/sites-enabled/
a2ensite orange.local.conf
service apache2 restart
cd /var/www/orange
curl -Ss https://getcomposer.org/installer | php
php composer.phar install --no-progress
echo "** [ZEND] Visit http://orange.local in your browser for to view the application **"
