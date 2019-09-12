; test set
(define set1 '(1 2 3 4 5 6 7 8 9))
(define set2 '(3 4 5 11 12 13 14))
(define set3 '(4 5 6 7))
(define set4 '(1 2 3 4 5 6 7 8 9))

; union
(print (union set1 set2))
; ==> (1 2 6 7 8 9 3 4 5 11 12 13 14)

; intersection
(print (intersect set1 set2))
; ==> (3 4 5)

; difference
(print (diff set1 set2))
; ==> (1 2 6 7 8 9)

; subset (no predefined function)
(define (subset? a b)
   (all (lambda (i) (has? b i)) a))
(print (subset? set3 set1))
; ==> #true
(print (subset? set3 set2))
; ==> #false

; equality
(print (equal? set1 set2))
; ==> #false
(print (equal? set1 set4))
; ==> #true
