#lang racket

(require math/number-theory)

(define (prime*? n) (= (totient n) (sub1 n)))

(for ([n (in-range 1 26)])
  (printf "φ(~a) = ~a~a~a\n"
          n
          (totient n)
          (if (prime*? n) " is prime" "")
          (if (prime? n) " (confirmed)" "")))

(for/fold ([count 0] #:result (void)) ([n (in-range 1 10001)])
   (define new-count (if (prime*? n) (add1 count) count))
   (when (member n '(100 1000 10000))
     (printf "Primes up to ~a: ~a\n" n new-count))
   new-count)
