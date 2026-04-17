FROM pkpofficial/ojs:3_3_0-14

USER root

# 1. Pastas e Permissões fundamentais
RUN mkdir -p /var/www/files /var/www/html/public /etc/apache2/conf-enabled \
    && chmod -R 777 /var/www/html /var/www/files /etc/apache2

# 2. Ativar módulos de Proxy e Header do Apache
RUN a2dismod mpm_event || true && a2enmod mpm_prefork || true && a2enmod headers || true

# 3. O PULO DO GATO: Injetar código PHP no topo do index.php
# Isso força o OJS a reconhecer o HTTPS do Railway antes mesmo de carregar o sistema
RUN sed -i "1a \$_SERVER['HTTPS'] = 'on';" /var/www/html/index.php

# 4. Configuração de Proxy no Apache
RUN echo "SetEnvIf X-Forwarded-Proto https HTTPS=on" >> /etc/apache2/apache2.conf \
    && echo "RequestHeader set X-Forwarded-Proto 'https'" >> /etc/apache2/apache2.conf

# 5. Criar arquivo de config vazio para o instalador conseguir gravar
RUN touch /var/www/html/config.inc.php && chmod 777 /var/www/html/config.inc.php

EXPOSE 80
