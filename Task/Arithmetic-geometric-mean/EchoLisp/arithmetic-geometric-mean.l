(lib 'math)

(define (agm a g)
    (if (~= a g) a
       (agm (// (+ a g ) 2) (sqrt (* a g)))))

(math-precision)
    → 0.000001 ;; default
(agm 1 (/ 1 (sqrt 2)))
    → 0.8472130848351929
(math-precision 1.e-15)
    → 1e-15
(agm 1 (/ 1 (sqrt 2)))
    → 0.8472130847939792
