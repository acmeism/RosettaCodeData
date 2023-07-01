(define (foo x)
  (define (bar y) (+ x y))
  (bar 2))
(foo 1) ; => 3
(bar 1) ; => error
