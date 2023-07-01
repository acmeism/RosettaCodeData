#!/bin/sh

LDAP_HOST="localhost"
LDAP_PORT=11389
LDAP_DN_STR="uid=admin,ou=system"
LDAP_CREDS="********"
LDAP_BASE_DN="ou=users,o=mojo"
LDAP_SCOPE="sub"
LDAP_FILTER="(&(objectClass=person)(&(uid=*mil*)))"
LDAP_ATTRIBUTES="dn cn sn uid"

ldapsearch \
  -s base \
  -h $LDAP_HOST \
  -p $LDAP_PORT \
  -LLL \
  -x \
  -v \
  -s $LDAP_SCOPE \
  -D $LDAP_DN_STR \
  -w $LDAP_CREDS \
  -b $LDAP_BASE_DN \
  $LDAP_FILTER \
  $LDAP_ATTRIBUTES
