#lang racket

(define (expt:0^0=1 r p)
  (if (zero? r) 0 (expt r p)))

(define (munchausen-number? n (t n))
  (if (zero? n)
      (zero? t)
      (let-values (([q r] (quotient/remainder n 10)))
        (munchausen-number? q (- t (expt:0^0=1 r r))))))

(module+ main
  (for-each displayln (filter munchausen-number? (range 1 (add1 5000)))))

(module+ test
  (require rackunit)
  ;; this is why we have the (if (zero? r)...) test
  (check-equal? (expt 0 0) 1)
  (check-equal? (expt:0^0=1 0 0) 0)
  (check-equal? (expt:0^0=1 0 4) 0)
  (check-equal? (expt:0^0=1 3 4) (expt 3 4))
  ;; given examples
  (check-true (munchausen-number? 1))
  (check-true (munchausen-number? 3435))
  (check-false (munchausen-number? 3))
  (check-false (munchausen-number? -45) "no recursion on -ve numbers"))
