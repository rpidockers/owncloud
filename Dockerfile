#
# rpidockers/owncloud Dockerfile
#
 
FROM resin/rpi-raspbian:jessie

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y wget ca-certificates

RUN apt-get -y install bzip2 apache2 libapache2-mod-php5 php5-gd php5-json php5-mysql php5-sqlite php5-pgsql php5-curl php5-intl php5-mcrypt php5-imagick

ENV OWNCLOUD_VERSION 8.2.2

RUN cd /tmp && \
    wget https://download.owncloud.org/community/owncloud-$OWNCLOUD_VERSION.tar.bz2 && \
    tar -xjf owncloud-$OWNCLOUD_VERSION.tar.bz2 && \
    rm owncloud-$OWNCLOUD_VERSION.tar.bz2 && \
    mv owncloud /var/www/html

RUN a2enmod rewrite && \
    a2enmod headers && \
    a2enmod env && \
    a2enmod dir && \
    a2enmod mime

ADD owncloud.conf /etc/apache2/sites-available/owncloud.conf

RUN ln -s /etc/apache2/sites-available/owncloud.conf /etc/apache2/sites-enabled/owncloud.conf

ENV APACHE_PID_FILE=/tmp/apache.pid
ENV APACHE_RUN_USER=www-data
ENV APACHE_LOG_DIR=/tmp
ENV APACHE_RUN_GROUP=www-data
ENV APACHE_LOCK_DIR=/tmp

VOLUME /var/www/html/owncloud/data

CMD /usr/sbin/apache2 -X

