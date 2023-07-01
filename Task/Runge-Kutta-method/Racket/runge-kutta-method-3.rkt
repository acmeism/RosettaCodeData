(define (F t y) (* t (sqrt y)))

(define (exact-solution t) (* 1/16 (sqr (+ 4 (sqr t)))))

(define numeric-solution
    (ODE-solve F '(0 1) #:x-max 10 #:step 1 #:method (step-subdivision 10 RK4)))

(for ([s numeric-solution])
  (match-define (list t y) s)
  (printf "t=~a\ty=~a\terror=~a\n" t y (- y (exact-solution t))))
