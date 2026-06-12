#lang racket

(require math/number-theory)

(define (extra-prime? p)
  (define (prime-sum-of-prime-digits? p (s 0))
    (if (zero? p)
        (prime? s)
        (let-values (((q r) (quotient/remainder p 10)))
          (case r
            ((2 3 5 7) (prime-sum-of-prime-digits? q (+ s r)))
            (else #f)))))
  (and (prime? p) (prime-sum-of-prime-digits? p)))

(displayln (filter extra-prime? (range 10000)))
