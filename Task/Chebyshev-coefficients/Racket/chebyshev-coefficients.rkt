#lang typed/racket
(: chebft (Real Real Nonnegative-Integer (Real -> Real) -> (Vectorof Real)))
(define (chebft a b n func)
  (define b-a/2 (/ (- b a) 2))
  (define b+a/2 (/ (+ b a) 2))
  (define pi/n (/ pi n))
  (define fac (/ 2 n))

  (define f (for/vector : (Vectorof Real)
              ((k : Nonnegative-Integer (in-range n)))
              (define y (cos (* pi/n (+ k 1/2))))
              (func (+ (* y b-a/2) b+a/2))))

  (for/vector : (Vectorof Real)
    ((j : Nonnegative-Integer (in-range n)))
    (define s (for/sum : Real
                ((k : Nonnegative-Integer (in-range n)))
                (* (vector-ref f k)
                   (cos (* pi/n j (+ k 1/2))))))
    (* fac s)))

(module+ test
  (chebft 0 1 10 cos))
;; Tim Brown 2015
