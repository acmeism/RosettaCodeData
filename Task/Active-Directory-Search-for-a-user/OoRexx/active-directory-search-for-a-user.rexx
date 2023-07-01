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
    '2>&1'                    ,
    '|'                       ,
    'rxqueue'                 ,
    ''

  address command,
    ldapCommand

  ldapResult. = ''
  loop ln = 1 to queued()
    parse pull line
    ldapResult.0  = ln
    ldapResult.ln = line
    end ln

  loop ln = 1 to ldapResult.0
    parse var ldapResult.ln 'dn:'  dn_   ,
      0                     'uid:' uid_  ,
      0                     'sn:'  sn_   ,
      0                     'cn:'  cn_
    select
      when length(strip(dn_,  'b')) > 0 then dn  = dn_
      when length(strip(uid_, 'b')) > 0 then uid = uid_
      when length(strip(sn_,  'b')) > 0 then sn  = sn_
      when length(strip(cn_,  'b')) > 0 then cn  = cn_
      otherwise nop
      end
    end ln

  say 'Distiguished Name:' dn
  say '      Common Name:' cn
  say '          Surname:' sn
  say '           userID:' uid

  return
end
exit
