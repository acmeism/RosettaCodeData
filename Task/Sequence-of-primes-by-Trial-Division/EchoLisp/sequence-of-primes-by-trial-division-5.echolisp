(define (g-next-prime n)
    (define next
        (for ((p [n .. ] )) #:break (is-prime? p) => p ))
    (yield next)
    (1+ next))

(define g-primes (make-generator g-next-prime 2))

(take g-primes 25)
    → (2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97)
