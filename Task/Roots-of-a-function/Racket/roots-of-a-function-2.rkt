(define (secant f a b)
  (let next ([x1 a] [y1 (f a)] [x2 b] [y2 (f b)] [n 50])
    (define x3 (/ (- (* x1 y2) (* x2 y1)) (- y2 y1)))
    (cond
      ; if the method din't converge within given interval
      ; switch to more robust bisection method
      [(or (not (< a x3 b)) (zero? n)) (bisection f a b)]
      [(almost-equal? x3 x2) x3]
      [else (next x2 y2 x3 (f x3) (sub1 n))])))

(define (bisection f x1 x2)
  (let divide ([a x1] [b x2])
    (and (<= (* (f a) (f b)) 0)
         (let ([c (* 0.5 (+ a b))])
           (if (almost-equal? a b)
               c
               (or (divide a c) (divide c b)))))))
