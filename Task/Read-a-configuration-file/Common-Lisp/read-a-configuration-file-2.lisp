READ-CONFIG> (with-open-file (s "test.cfg") (parse-config s))
#<HASH-TABLE :TEST EQUAL :COUNT 4 {100BD25B43}>
READ-CONFIG> (maphash (lambda (k v) (print (list k v))) *)

("FULLNAME" "Foo Barber")
("FAVOURITEFRUIT" "banana")
("NEEDSPEELING" T)
("OTHERFAMILY" ("Rhu Barber" "Harry Barber"))
NIL
READ-CONFIG> (gethash "SEEDSREMOVED" **)
NIL
NIL
