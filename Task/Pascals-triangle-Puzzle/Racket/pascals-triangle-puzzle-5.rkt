(define x (- (cramer2 eqn20 eqn40 cell-v cell-x cell-z)))
(define z (- (cramer2 eqn20 eqn40 cell-v cell-z cell-x)))

(displayln (list "X" x))
(displayln (list "Y" (+ x z)))
(displayln (list "Z" z))
