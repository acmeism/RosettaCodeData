#lang racket
(require math)

(define (semiprime n)
  "Alternative implementation.
Check if there are two prime factors whose product is the argument
or if there is a single prime factor whose square is the argument"
  (let ([prime-factors (factorize n)])
    (or (and (= (length prime-factors) 1)
	     (= (expt (caar prime-factors) (cadar prime-factors)) n))
	(and (= (length prime-factors) 2)
	     (= (foldl (λ (x y) (* (car x) y)) 1 prime-factors) n)))))
