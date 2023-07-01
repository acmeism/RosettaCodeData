(define (fact n (acc 1))
(if (zero? n) acc
    (fact (1- n) (* n acc))))
(fact 10)
    → 3628800
