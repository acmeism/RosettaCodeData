(scl 2)

(class +Account +Entity)
(rel id        (+Key +Number))
(rel created   (+Date))
(rel active    (+Bool))
(rel username  (+Key +String))
(rel balance   (+Number) 2)
(rel age       (+Number))
(rel notes     (+Blob))

(pool "account.db")  # Create database

(new! '(+Account)
   'id 12345
   'username "John Doe"
   'balance 77.22
   'created (date 2009 5 13) )

(new! '(+Account)
   'id 12346
   'username "Jane Miller"
   'active T
   'created (date 2009 5 14)
   'balance 123.75 )

(let Fmt (-13 -10 -9 -11 10)
   (tab Fmt "account_id" "created" "active" "username" "balance")
   (for This (collect 'id '+Account)
      (tab Fmt
         (: id)
         (dat$ (: created))
         (if (: active) "Yes" "No")
         (: username)
         (money (: balance)) ) ) )
