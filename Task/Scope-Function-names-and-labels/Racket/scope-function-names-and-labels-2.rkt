(define (foo x)
  (define (bar y) (+ x y))
  bar)
(foo 1)     ; => #<procedure:bar>
((foo 1) 2) ; => 3
