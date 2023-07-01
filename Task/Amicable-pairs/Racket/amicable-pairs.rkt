#lang racket
(require "proper-divisors.rkt")
(define SCOPE 20000)

(define P
  (let ((P-v (vector)))
    (λ (n)
      (set! P-v (fold-divisors P-v n 0 +))
      (vector-ref P-v n))))

;; returns #f if not an amicable number, amicable pairing otherwise
(define (amicable? n)
  (define m (P n))
  (define m-sod (P m))
  (and (= m-sod n)
       (< m n) ; each pair exactly once, also eliminates perfect numbers
       m))

(void (amicable? SCOPE)) ; prime the memoisation

(for* ((n (in-range 1 (add1 SCOPE)))
       (m (in-value (amicable? n)))
       #:when m)
  (printf #<<EOS
amicable pair: ~a, ~a
  ~a: divisors: ~a
  ~a: divisors: ~a


EOS
          n m n (proper-divisors n)  m (proper-divisors m)))
