#lang racket
(define (m-mult m1 m2)
  (for/list ([r m1])
    (for/list ([c (apply map list m2)])
      (apply + (map * r c)))))
(m-mult '((1 2) (3 4)) '((5 6) (7 8)))
;; -> '((19 22) (43 50))
