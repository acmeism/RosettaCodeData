(define (optimised-flip-doors doors)
  (define (flip-all i)
    (cond ((> i (floor (sqrt *max-doors*))) doors)
          (else
           (vector-set! doors (- (* i i) 1) #t)
           (flip-all (+ i 1)))))
  (flip-all 1))

(show-doors (optimised-flip-doors (make-vector *max-doors* #f)))
