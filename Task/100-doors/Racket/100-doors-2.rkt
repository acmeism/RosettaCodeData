#lang racket

(for-each (lambda (x) (printf "~a is open\n" x))
            (filter (lambda (x)
                      (exact-integer? (sqrt x)))
                    (sequence->list (in-range 1 101))))
