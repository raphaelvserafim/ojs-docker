FROM pkpofficial/ojs:3_3_0-14

USER root


RUN mkdir -p /var/www/files /var/www/html/public /etc/apache2/conf-enabled \
    && chmod -R 777 /var/www/html \
    && chmod -R 777 /var/www/files \
    && chmod -R 777 /etc/apache2


RUN a2dismod mpm_event || true && a2enmod mpm_prefork || true && a2enmod headers || true

 
RUN echo "SetEnvIf X-Forwarded-Proto https HTTPS=on" >> /etc/apache2/apache2.conf \
    && echo "RequestHeader set X-Forwarded-Proto 'https'" >> /etc/apache2/apache2.conf \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf

RUN touch /var/www/html/config.inc.php && chmod 777 /var/www/html/config.inc.php

RUN echo "memory_limit=512M" > /usr/local/etc/php/conf.d/ojs-limits.ini

EXPOSE 80
