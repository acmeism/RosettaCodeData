(define (s-next-prime n) ;; n odd
    (for ((p [n (+ n 2) .. ] ))
    #:break (is-prime? p) => (cons p (+ p 2))))

(define s-primes (stream-cons 2 (make-stream s-next-prime 3)))


(take s-primes 25)
    → (2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97)
