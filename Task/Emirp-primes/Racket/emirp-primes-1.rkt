#lang racket
(require math/number-theory)

(define (stigid n)
  (define (inr n a) (if (= 0 n) a (inr (quotient n 10) (+ (* 10 a) (modulo n 10)))))
  (inr n 0))

(define (emirp-prime? n)
  (define u (stigid n))
  (and (not (= u n)) (prime? n) (prime? u)))

(printf "\"show the first twenty emirps.\"~%")
(for/list ((n (sequence-filter emirp-prime? (in-range 11 +Inf.0 2))) (_ (in-range 20))) n)

(printf "\"show all emirps between 7,700 and 8,000\"~%")
(for/list ((n (sequence-filter emirp-prime? (in-range 7701 8000 2)))) n)

(printf "\"show the 10,000th emirp\"~%")
(let loop ((i 10000) (p 9))
  (define p+2 (+ p 2))
  (cond [(not (emirp-prime? p+2)) (loop i p+2)] [(= i 1) p+2] [else (loop (- i 1) p+2)]))
