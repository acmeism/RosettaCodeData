#lang racket

(require math/number-theory)

(define ((wilson-prime? n) p)
  (and (>= p n)
       (prime? p)
       (divides? (sqr p)
                 (- (* (factorial (- n 1))
                       (factorial (- p n)))
                    (expt -1 n)))))

(define primes<11000 (filter prime? (range 1 11000)))

(for ((n (in-range 1 (add1 11))))
  (printf "~a: ~a~%" n (filter (wilson-prime? n) primes<11000)))
