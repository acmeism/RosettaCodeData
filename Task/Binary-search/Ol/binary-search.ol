(define (binary-search value vector)
   (let helper ((low 0)
                (high (- (vector-length vector) 1)))
      (unless (< high low)
         (let ((middle (quotient (+ low high) 2)))
            (cond
               ((> (vector-ref vector middle) value)
                  (helper low (- middle 1)))
               ((< (vector-ref vector middle) value)
                  (helper (+ middle 1) high))
               (else middle))))))

(print
   (binary-search 12 [1 2 3 4 5 6 7 8 9 10 11 12 13]))
; ==> 12
