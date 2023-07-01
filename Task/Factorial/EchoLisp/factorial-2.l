(define (fact n)
    (if (zero? n) 1
    (* n (fact (1- n)))))
(remember 'fact)
(fact 10)
    → 3628800
