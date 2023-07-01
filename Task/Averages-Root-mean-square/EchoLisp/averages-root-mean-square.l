(define (rms xs)
    (sqrt (// (for/sum ((x xs)) (* x x)) (length xs))))

(rms (range 1 11))
    → 6.2048368229954285
