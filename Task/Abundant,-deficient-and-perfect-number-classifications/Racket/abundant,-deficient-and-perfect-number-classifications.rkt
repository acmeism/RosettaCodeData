#lang racket
(require "proper-divisors.rkt")
(define SCOPE 20000)

(define P
  (let ((P-v (vector)))
    (λ (n)
      (set! P-v (fold-divisors P-v n 0 +))
      (vector-ref P-v n))))

(define-values
  (a d p)
  (for/fold ((a 0) (d 0) (p 0))
            ((n (in-range SCOPE 0 -1))) ; doing this backwards initialises the memo
    (match (- (P n) n)
      [0             (values a d (add1 p))]    ; perfect
      [(? negative?) (values a (add1 d) p)]    ; deficient
      [(? positive?) (values (add1 a) d p)]))) ; abundant

(printf #<<EOS
Between 1 and ~s:
  ~a abundant numbers
  ~a deficient numbers
  ~a perfect numbers
EOS
        SCOPE a d p)
