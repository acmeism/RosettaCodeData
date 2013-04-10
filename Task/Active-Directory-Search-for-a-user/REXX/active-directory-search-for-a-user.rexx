/* Rexx */
do
  LDAP_URL        = 'ldap://localhost:11389'
  LDAP_DN_STR     = 'uid=admin,ou=system'
  LDAP_CREDS      = '********'
  LDAP_BASE_DN    = 'ou=users,o=mojo'
  LDAP_SCOPE      = 'sub'
  LDAP_FILTER     = '"(&(objectClass=person)(&(uid=*mil*)))"'
  LDAP_ATTRIBUTES = '"dn" "cn" "sn" "uid"'

  ldapCommand =               ,
    'ldapsearch'              ,
    '-s base'                 ,
    '-H' LDAP_URL             ,
    '-LLL'                    ,
    '-x'                      ,
    '-v'                      ,
    '-s' LDAP_SCOPE           ,
    '-D' LDAP_DN_STR          ,
    '-w' LDAP_CREDS           ,
    '-b' LDAP_BASE_DN         ,
    LDAP_FILTER               ,
    LDAP_ATTRIBUTES           ,
    ''

  say ldapCommand
  address command,
    ldapCommand

  return
end
exit
