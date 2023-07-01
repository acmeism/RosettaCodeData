(redef send (Msg Obj . @)
   (or
      (pass try Msg Obj)
      (pass 'no-applicable-method> Obj Msg) ) )

(de no-applicable-method> (This Msg)
   (pack "No method for " Msg " on " This) )

(class +A)

(dm do-something> ()
   (pack "Do something to " This) )
