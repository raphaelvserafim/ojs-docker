FROM pkpofficial/ojs:3_3_0-14

USER root

# 1. Ajustes de módulos e pastas iniciais
RUN a2dismod mpm_event || true && a2enmod mpm_prefork || true && a2enmod headers || true \
    && mkdir -p /var/www/files /var/www/html/public \
    && chmod -R 755 /etc/apache2

# 2. Fix do HTTPS (Segurança de conexão)
RUN sed -i "1a \$_SERVER['HTTPS'] = 'on';" /var/www/html/index.php \
    && echo "SetEnvIf X-Forwarded-Proto https HTTPS=on" >> /etc/apache2/apache2.conf \
    && echo "RequestHeader set X-Forwarded-Proto 'https'" >> /etc/apache2/apache2.conf

# 3. ENTRYPOINT SEGURO: Ajusta o dono da pasta no boot do container
# Isso resolve o erro de "not writable" sem escancarar a segurança com 777
ENTRYPOINT ["sh", "-c", "chown -R www-data:www-data /var/www/files /var/www/html/public && exec /usr/local/bin/docker-php-entrypoint apache2-foreground"]

EXPOSE 80
