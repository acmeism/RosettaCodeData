#lang racket
(require net/ldap)
(ldap-authenticate "ldap.somewhere.com" 389 "uid=username,ou=people,dc=somewhere,dc=com" password)
