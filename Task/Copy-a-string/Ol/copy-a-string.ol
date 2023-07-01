(define a "The String.")

; copy the string
(define b (runes->string (string->runes a)))
(print "a: " a)
(print "b: " b)
(print "b is an a: " (eq? a b))
(print "b same as a: " (equal? a b))

; another way: marshal the string
(define c (fasl-decode (fasl-encode a) #f))
(print "a: " a)
(print "c: " c)
(print "c is an a: " (eq? a c))
(print "c same as a: " (equal? a c))
