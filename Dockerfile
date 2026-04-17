FROM pkpofficial/ojs:3_3_0-14

USER root

# 1. Cria as pastas caso elas não existam para evitar o erro de "No such file"
RUN mkdir -p /etc/apache2/conf-enabled/ \
    && mkdir -p /var/www/files \
    && mkdir -p /var/www/html

# 2. Tenta ajustar o Apache (ignora se o módulo não existir)
RUN a2dismod mpm_event || true
RUN a2enmod mpm_prefork || true

# 3. Dá permissão total na pasta do Apache e do OJS de forma mais abrangente
# O "|| true" no final garante que se um arquivo faltar, o build não quebre
RUN chmod -R 777 /etc/apache2/ || true
RUN chmod -R 777 /var/www/html/ || true
RUN chmod -R 777 /var/www/files/ || true

# 4. Garante que o diretório de trabalho seja o do OJS
WORKDIR /var/www/html

EXPOSE 80
