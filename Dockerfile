FROM pkpofficial/ojs:3_3_0-14

USER root

# 1. Criar as pastas e dar permissão inicial
RUN mkdir -p /var/www/files /var/www/html/public \
    && chmod -R 777 /var/www/html /etc/apache2 /var/www/files

# 2. Fix do HTTPS (Mata a tela preta de "Not Secure")
# Injetamos o código PHP no topo do index.php para forçar o SSL do Railway
RUN a2enmod headers || true \
    && sed -i "1a \$_SERVER['HTTPS'] = 'on';" /var/www/html/index.php \
    && echo "SetEnvIf X-Forwarded-Proto https HTTPS=on" >> /etc/apache2/apache2.conf

# 3. COMANDO DE INICIALIZAÇÃO (Corrigido para esta imagem)
# Dá permissão ao volume NO MOMENTO DO BOOT e inicia o Apache
CMD ["sh", "-c", "chmod -R 777 /var/www/files /var/www/html/public && apache2-foreground"]

EXPOSE 80
