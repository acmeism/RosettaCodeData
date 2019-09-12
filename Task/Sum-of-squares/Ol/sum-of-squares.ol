(define (sum-of-squares l)
   (fold + 0 (map * l l)))

(print (sum-of-squares '(1 2 3 4 5 6 7 8 9 10)))
; ==> 385
