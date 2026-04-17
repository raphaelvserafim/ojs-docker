FROM pkpofficial/ojs:3_3_0-14

USER root

# 1. Cria TODAS as pastas necessárias de uma vez (incluindo a do PHP que deu erro)
RUN mkdir -p /var/www/files \
    && mkdir -p /var/www/html/public \
    && mkdir -p /etc/apache2/conf-enabled \
    && mkdir -p /usr/local/etc/php/conf.d/ \
    && chmod -R 777 /var/www/html \
    && chmod -R 777 /var/www/files \
    && chmod -R 777 /etc/apache2

# 2. Ajustes de módulos do Apache
RUN a2dismod mpm_event || true \
    && a2enmod mpm_prefork || true \
    && a2enmod headers || true

# 3. FIX DE SEGURANÇA (HTTPS) para o Railway
RUN echo "SetEnvIf X-Forwarded-Proto https HTTPS=on" >> /etc/apache2/apache2.conf \
    && echo "RequestHeader set X-Forwarded-Proto 'https'" >> /etc/apache2/apache2.conf \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf

# 4. Prepara o arquivo de configuração
RUN touch /var/www/html/config.inc.php && chmod 777 /var/www/html/config.inc.php

# 5. Ajusta a memória do PHP (Criando a pasta antes para evitar o erro anterior)
RUN mkdir -p /usr/local/etc/php/conf.d/ \
    && echo "memory_limit=512M" > /usr/local/etc/php/conf.d/ojs-limits.ini || true

EXPOSE 80
