#lang typed/racket
(require math/number-theory)

(: wieferich-prime? (-> Positive-Integer Boolean))

(define (wieferich-prime? p)
  (and (prime? p)
       (divides? (* p p) (sub1 (expt 2 (sub1 p))))))

(module+ main
  (define wieferich-primes<5000
    (for/list : (Listof Integer) ((p (sequence-filter wieferich-prime?
                                                      (in-range 1 5000))))
      p))
  wieferich-primes<5000)
