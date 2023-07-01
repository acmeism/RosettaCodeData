#!/usr/bin/picolisp /usr/lib/picolisp/lib.l

(load "@ext.l" "@lib/http.l" "@lib/xhtml.l" "@lib/form.l")

(de start ()
   (and (app) (zero *Number))
   (action
      (html 0 "Enable/Disable" "@lib.css" NIL
         (form NIL
            (gui '(+Var +Able +NumField) '*Number '(=0 *Number) 20 "Value")
            (gui '(+Able +JS +Button) '(> 10 *Number) "increment"
               '(inc '*Number) )
            (gui '(+Able +JS +Button) '(gt0 *Number) "decrement"
               '(dec '*Number) ) ) ) ) )

(server 8080 "!start")
(wait)
