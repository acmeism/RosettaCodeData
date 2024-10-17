(define (fac35? x)
    (or (zero? (remainder x 3))
        (zero? (remainder x 5))))

(define (fac35filt x tot)
    (+ tot (if (fac35? x) x 0)))

(fold fac35filt 0 (iota 1000))
