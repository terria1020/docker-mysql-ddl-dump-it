from ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

ENV MYSQL_ROOT_PASSWORD=toor
ENV ORG_HOST={ORG_HOST}
ENV ORG_PORT={ORG_PORT}
ENV ORG_USER={ORG_USER}
ENV ORG_PASSWORD={ORG_PASSWORD}
ENV ORG_DB={ORG_DB}
ENV WAIT={WAIT}

COPY script/dumpit.sh /root/

RUN apt-get update
RUN apt-get install -y mysql-server
RUN chmod +x /root/dumpit.sh

ENTRYPOINT [ "sh", "-c" ]
CMD [ "/root/dumpit.sh" ]