FROM pkpofficial/ojs:3_3_0-14

USER root

# 1. Cria pastas e garante permissões totais para o instalador e para o OJS
RUN mkdir -p /var/www/files /var/www/html/public /etc/apache2/conf-enabled \
    && chmod -R 777 /var/www/html \
    && chmod -R 777 /var/www/files \
    && chmod -R 777 /etc/apache2

# 2. Corrige o erro de múltiplos MPMs do Apache (conflito comum nessa imagem)
RUN a2dismod mpm_event || true && a2enmod mpm_prefork || true

# 3. FIX DE SEGURANÇA (HTTPS): Faz o OJS entender que o Railway usa SSL
# Isso remove o erro de "Information not secure" ao clicar em instalar
RUN echo "SetEnvIf X-Forwarded-Proto https HTTPS=on" >> /etc/apache2/apache2.conf \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf

# 4. Garante que o arquivo de configuração possa ser escrito pelo instalador web
RUN touch /var/www/html/config.inc.php && chmod 777 /var/www/html/config.inc.php

EXPOSE 80
