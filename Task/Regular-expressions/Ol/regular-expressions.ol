; matching:
(define regex (string->regex "m/aa(bb|cc)dd/"))
(print (regex "aabbddx")) ; => true
(print (regex "aaccddx")) ; => true
(print (regex "aabcddx")) ; => false

; substitute part of a string:
(define regex (string->regex "s/aa(bb|cc)dd/HAHAHA/"))
(print (regex "aabbddx")) ; => HAHAHAx
(print (regex "aaccddx")) ; => HAHAHAx
(print (regex "aabcddx")) ; => false
