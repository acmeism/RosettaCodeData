#!/usr/bin/picolisp /usr/lib/picolisp/lib.l

(load "@ext.l" "@lib/http.l" "@lib/xhtml.l" "@lib/form.l")

(zero *Count)

(de start ()
   (app)
   (action
      (html 0 "Clicks" NIL NIL
         (form NIL
            (gui '(+Init +TextField) "There have been no clicks yet")
            (----)
            (gui '(+JS +Button) "click me"
               '(set> (field -1)
                  (pack "Clicked " (inc '*Count) " times") ) ) ) ) ) )

(server 8080 "!start")
(wait)
