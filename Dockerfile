FROM pkpofficial/ojs:stable-3_3_0

USER root

# Resolve o erro de conflito de MPM do Apache
RUN a2dismod mpm_event || true
RUN a2enmod mpm_prefork || true

# Garante permissões de escrita para as pastas de configuração e arquivos
RUN chmod -R 777 /etc/apache2/conf-enabled/ /etc/apache2/apache2.conf /var/www/html/

# Cria e dá permissão à pasta de uploads (caso não exista)
RUN mkdir -p /var/www/files && chmod -R 777 /var/www/files

EXPOSE 80
