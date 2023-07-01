(define (fact n)
    (for/product ((f (in-range 2 (1+ n)))) f))
(fact 10)
    → 3628800
