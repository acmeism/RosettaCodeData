(define (fgen i) (lambda () (* i i)))
(define fs (for/vector ((i 10)) (fgen i))) ;; vector of 10 anonymous functions
((vector-ref fs 5)) ;; calls fs[5]
    → 25
