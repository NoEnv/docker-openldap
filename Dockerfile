FROM alpine:3.11

LABEL maintainer "NoEnv"
LABEL version "1.0.3"
LABEL description "OpenLDAP as Docker Image"

ARG lang="en_US.UTF-8"
ARG backend="mdb"
ARG version="2.4.48-r1"

ENV LANG "${lang}"
ENV USER "ldap"
ENV GROUP "$USER"

ADD openssh-lpk.schema /etc/openldap/schema/openssh-lpk.schema
ADD entrypoint.sh /usr/local/bin/entrypoint.sh
RUN apk add --no-cache --purge --clean-protected -u ca-certificates openldap=$version \
    openldap-clients openldap-overlay-ppolicy openldap-back-$backend \
 && mkdir /run/openldap \
 && chown $USER.$GROUP /run/openldap \
 && rm -rf /var/cache/apk/*

EXPOSE 389 636

VOLUME /ssl
VOLUME /etc/ldap
VOLUME /var/lib/ldap
VOLUME /var/restore

ENTRYPOINT [ "entrypoint.sh" ]
