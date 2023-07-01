;; adapted from Racket
;; (compose f g h ... ) is a built-in defined as :
;; (define (compose f g) (λ (x) (f (g x))))

(define (cube x) (expt x 3))
(define (cube-root x) (expt x (// 1 3)))
(define funlist (list sin cos cube))
(define ifunlist (list asin acos cube-root))

(for ([f funlist] [i ifunlist])
  (writeln ((compose i f) 0.5)))
→
    0.5
    0.4999999999999999
    0.5
