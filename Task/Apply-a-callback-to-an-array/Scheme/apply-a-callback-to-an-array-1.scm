(define (square n) (* n n))
(define x #(1 2 3 4 5))
(map square (vector->list x))
