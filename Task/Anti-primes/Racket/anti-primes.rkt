#lang racket

(require racket/generator
         math/number-theory)

(define (get-divisors n)
  (apply * (map (λ (factor) (add1 (second factor))) (factorize n))))

(define antiprimes
  (in-generator
   (for/fold ([prev 0]) ([i (in-naturals 1)])
     (define divisors (get-divisors i))
     (when (> divisors prev) (yield i))
     (max prev divisors))))

(for/list ([i (in-range 20)] [antiprime antiprimes]) antiprime)
