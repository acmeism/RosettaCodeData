#lang racket
(require math/number-theory)

(define (second-bernoulli-number n)
  (if (= n 1) 1/2 (bernoulli-number n)))

(define (faulhaber-row:formulaic p)
  (let ((p+1 (+ p 1)))
    (reverse
     (for/list ((j (in-range p+1)))
       (* (/ p+1) (second-bernoulli-number j) (binomial p+1 j))))))

(define (sum-k^p:formulaic p n)
  (for/sum ((f (faulhaber-row:formulaic p)) (i (in-naturals 1)))
    (* f (expt n i))))

(module+ main
  (map faulhaber-row:formulaic (range 10))
  (sum-k^p:formulaic 17 1000))

(module+ test
  (require rackunit)
  (check-equal? (sum-k^p:formulaic 17 1000)
                (for/sum ((k (in-range 1 (add1 1000)))) (expt k 17))))
