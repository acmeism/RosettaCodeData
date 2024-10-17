(define (median l)
  (* (+ (list-ref (sort l less?) (round (/ (- (length l) 1) 2)))
        (list-ref (sort l less?) (round (/ (length l) 2)))) 0.5))
