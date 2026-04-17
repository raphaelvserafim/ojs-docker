FROM pkpofficial/ojs:3_3_0-14 # Ou a versão que desejar

USER root

# Corrigir o erro "More than one MPM loaded" desativando o event e ativando o prefork
RUN a2dismod mpm_event && a2enmod mpm_prefork

# Ajustar permissões para que o script de inicialização possa editar os arquivos mesmo sem ser root
RUN chmod -R 777 /etc/apache2/conf-enabled/ /etc/apache2/apache2.conf /var/www/html/

# Retornar para o usuário padrão do OJS (se houver) ou manter root para Railway
USER root

EXPOSE 80
