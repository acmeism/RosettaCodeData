(define (dot-product a b)
  (apply + (map * a b)))

(print (dot-product '(1 3 -5) '(4 -2 -1)))
; ==> 3
