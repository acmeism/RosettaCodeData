(define (A xs) (// (for/sum ((x xs)) x) (length xs)))

(define (G xs) (expt (for/product ((x xs)) x) (// (length xs))))

(define (H xs) (// (length xs) (for/sum ((x xs)) (// x))))

(define xs (range 1 11))
(and (>= (A xs) (G xs)) (>= (G xs) (H xs)))
    → #t
