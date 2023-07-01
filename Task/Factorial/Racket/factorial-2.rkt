(define (factorial n)
  (define (fact n acc)
    (if (= 0 n)
        acc
        (fact (- n 1) (* n acc))))
  (fact n 1))
