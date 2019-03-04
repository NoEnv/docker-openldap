#!/bin/sh -e

function error() {
    echo "ERROR: $*" 1>&2
    exit
}

# restore if required
if test -e /var/restore/*data.ldif; then
    rm -r /var/lib/ldap/* || true
    slapadd -f /etc/ldap/slapd.conf -l /var/restore/*data.ldif 2> /dev/null
    rm -f /var/restore/*data.ldif
fi

# run
mkdir -p /var/lib/openldap/run
chown -R ${USER}.${GROUP} /var/lib/ldap /etc/ldap /var/lib/openldap
chmod 700 /var/lib/ldap
/usr/sbin/slapd -u $USER -g $GROUP -d 0 -h "ldap:/// ldaps:/// ldapi:///" -f /etc/ldap/slapd.conf
