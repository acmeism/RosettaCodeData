(de ldapsearch (Sn)
   (in
      (list "ldapsearch" "-xH" "ldap://db.debian.org"
         "-b" "dc=debian,dc=org"
         (pack "sn=" Sn) )
      (list
         (cons 'cn (prog (from "cn: ") (line T)))
         (cons 'uid (prog (from "uid: ") (line T))) ) ) )
