; matching:
(print (m/aa(bb|cc)dd/ "aabbddx")) ; => true
(print (m/aa(bb|cc)dd/ "aaccddx")) ; => true
(print (m/aa(bb|cc)dd/ "aabcddx")) ; => false

; substitute part of a string:
(print (s/aa(bb|cc)dd/HAHAHA/ "aabbddx")) ; => HAHAHAx
(print (s/aa(bb|cc)dd/HAHAHA/ "aaccddx")) ; => HAHAHAx
(print (s/aa(bb|cc)dd/HAHAHA/ "aabcddx")) ; => false
