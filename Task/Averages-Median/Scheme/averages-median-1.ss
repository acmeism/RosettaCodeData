(define (median l)
  (* (+ (list-ref (bubble-sort l >) (round (/ (- (length l) 1) 2)))
        (list-ref (bubble-sort l >) (round (/ (length l) 2)))) 0.5))
