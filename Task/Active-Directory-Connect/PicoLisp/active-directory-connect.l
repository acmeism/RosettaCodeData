(unless (=0 (setq Ldap (native "libldap.so" "ldap_open" 'N "example.com" 389)))
   (quit "Can't open LDAP") )

(native "libldap.so" "ldap_simple_bind_s" 'I Ldap "user" "password")
