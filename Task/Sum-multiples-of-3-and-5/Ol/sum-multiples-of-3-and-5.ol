(print
(fold (lambda (s x)
         (+ s (if (or (zero? (remainder x 3)) (zero? (remainder x 5))) x 0)))
   0 (iota 1000)))
; ==> 233168
