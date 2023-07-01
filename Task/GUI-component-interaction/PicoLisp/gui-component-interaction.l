#!/usr/bin/picolisp /usr/lib/picolisp/lib.l

(load "@ext.l" "@lib/http.l" "@lib/xhtml.l" "@lib/form.l")

(de start ()
   (and (app) (zero *Number))
   (action
      (html 0 "Increment" "@lib.css" NIL
         (form NIL
            (gui '(+Var +NumField) '*Number 20 "Value")
            (gui '(+JS +Button) "increment"
               '(inc '*Number) )
            (gui '(+Button) "random"
               '(ask "Reset to a random value?"
                  (setq *Number (rand)) ) ) ) ) ) )

(server 8080 "!start")
(wait)
