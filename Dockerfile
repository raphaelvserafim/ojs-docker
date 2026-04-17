FROM pkpofficial/ojs:3_3_0-14

USER root

# Ativar módulos necessários do Apache
RUN a2dismod mpm_event || true \
    && a2enmod mpm_prefork \
    && a2enmod headers \
    && a2enmod rewrite

# Ajuste correto de HTTPS atrás de proxy (Railway, etc)
RUN echo "SetEnvIf X-Forwarded-Proto https HTTPS=on" >> /etc/apache2/apache2.conf \
    && echo "RequestHeader set X-Forwarded-Proto 'https'" >> /etc/apache2/apache2.conf

# Criar diretórios necessários
RUN mkdir -p /var/www/files /var/www/html/public

# Permissões seguras (NÃO usar 777)
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www

# (Opcional) Se quiser garantir escrita no diretório files
RUN chmod -R 775 /var/www/files

# NÃO sobrescreve o CMD da imagem (isso era o problema!)
# A imagem do OJS já tem o startup correto configurado

EXPOSE 80
