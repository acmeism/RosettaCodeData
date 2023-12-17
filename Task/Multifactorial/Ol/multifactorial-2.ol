(define (!!!!! n) (multifactorial n 5))
(print (!!!!! 74))

(import (math infix-notation))
; register !!!!! as a postfix function
(define \\postfix-functions (put \\postfix-functions '!!!!! #t))

; now use "\\" as usual
(print (\\
   2 + 74!!!!!
))
