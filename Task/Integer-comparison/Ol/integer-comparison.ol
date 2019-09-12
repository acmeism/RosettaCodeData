(define (compare a b)
  (cond ((< a b) "A is less than B")
        ((> a b) "A is greater than B")
        ((= a b) "A equals B")))

(print (compare 1 2))
; ==> A is less than B

(print (compare 2 2))
; ==> A equals B

(print (compare 3 2))
; ==> A is greater than B

; manual user input:
(print (compare (read) (read)))
