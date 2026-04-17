FROM pkpofficial/ojs:3_3_0-14

USER root

RUN mkdir -p /var/www/files \
    && chmod -R 775 /var/www/files

EXPOSE 80
