(define (LegendreP-root n i)
  ; newton-raphson step
  (define (newton-step x)
    (- x (/ (LegendreP n x) (LegendreP′ n x))))
  ; initial guess
  (define x0 (cos (* pi (/ (- i 1/4) (+ n 1/2)))))
  ; computation of a root with relative accuracy 1e-15
  (if (< (abs x0) 1e-15)
      0
      (let next ([x′ (newton-step x0)] [x x0])
        (if (< (abs (/ (- x′ x) (+ x′ x))) 1e-15)
            x′
            (next (newton-step x′) x′)))))
