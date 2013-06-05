#lang racket
(for ([x (in-range 1 101)] #:when (exact-integer? (sqrt x)))
  (printf "~a is open\n" x))
