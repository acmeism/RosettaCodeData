(define (Δ-1 list)
(for/list ([x (cdr list)] [y list]) (- x y)))

(define (Δ-n n) (iterate Δ-1 n))

((Δ-n 9) '(90 47 58 29 22 32 55 5 55 73))
    →  (-2921)
