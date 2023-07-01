(define (Gauss-Legendre-quadrature n)
  ;; positive roots
  (define roots
    (for/list ([i (in-range (floor (/ n 2)))])
      (LegendreP-root n (+ i 1))))
  ;; weights for positive roots
  (define weights
    (for/list ([x (in-list roots)])
      (/ 2 (- 1 (sqr x)) (sqr (LegendreP′ n x)))))
  ;; all roots and weights
  (values (append (map - roots)
                  (if (odd? n) (list 0) '())
                  (reverse roots))
          (append weights
                  (if (odd? n) (list (/ 2 (sqr (LegendreP′ n 0)))) '())
                  (reverse weights))))
