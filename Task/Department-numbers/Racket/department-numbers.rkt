#lang racket
(cons '(police fire sanitation)
      (filter (λ (pfs) (and (not (check-duplicates pfs))
                            (= 12 (apply + pfs))
                            pfs))
              (cartesian-product (range 2 8 2) (range 1 8) (range 1 8))))
