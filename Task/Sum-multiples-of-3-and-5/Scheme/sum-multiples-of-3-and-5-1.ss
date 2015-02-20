(fold (lambda (x tot) (+ tot (if (or (zero? (remainder x 3)) (zero? (remainder x 5))) x 0))) 0 (iota 1000))
