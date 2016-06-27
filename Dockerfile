FROM crystalsource/crystal-webdev-server1404
MAINTAINER Mike Bertram <contact@crystalsource.de>

# Non interactive
ENV DEBIAN_FRONTEND noninteractive

# Install
RUN apt-get update
RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:ondrej/php5-5.6
RUN apt-get update && apt-get -y install python-software-properties
RUN apt-get -y --force-yes install libapache2-mod-php5 php5 php5-mysql php5-gd

# Enable apache mods.
RUN a2enmod php5
RUN a2enmod rewrite

# Configure zend-guard
ADD .docker/files/ZendGuardLoader56x64.so /opt/php/zend/ZendGuardLoader56x64.so
RUN echo "" >> /etc/php5/apache2/php.ini
RUN echo "[Zend]" >> /etc/php5/apache2/php.ini
RUN echo "zend_extension=/opt/php/zend/ZendGuardLoader56x64.so" >> /etc/php5/apache2/php.ini

# Clear Docroot
RUN rm -rf /var/www/html/*
ADD .docker/files/index.php /var/www/html/index.php

# CMD
CMD ["supervisord", "-n"]