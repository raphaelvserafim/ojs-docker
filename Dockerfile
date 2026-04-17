FROM pkpofficial/ojs:3_3_0-14

USER root

# 1. Ajustes iniciais de pastas e módulos
RUN a2dismod mpm_event || true && a2enmod mpm_prefork || true && a2enmod headers || true \
    && mkdir -p /var/www/files /var/www/html/public \
    && chmod -R 777 /etc/apache2

# 2. Fix do HTTPS (Segurança de conexão para o Railway)
RUN sed -i "1a \$_SERVER['HTTPS'] = 'on';" /var/www/html/index.php \
    && echo "SetEnvIf X-Forwarded-Proto https HTTPS=on" >> /etc/apache2/apache2.conf \
    && echo "RequestHeader set X-Forwarded-Proto 'https'" >> /etc/apache2/apache2.conf

# 3. ENTRYPOINT UNIVERSAL: Dá permissão total ao volume no boot
# Usamos chmod 777 aqui porque ele não depende de nome de usuário (evita o erro anterior)
ENTRYPOINT ["sh", "-c", "chmod -R 777 /var/www/files /var/www/html/public && exec /usr/local/bin/docker-php-entrypoint apache2-foreground"]

EXPOSE 80
