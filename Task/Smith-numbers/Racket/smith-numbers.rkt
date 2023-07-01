#lang racket
(require math/number-theory)

(define (sum-of-digits n)
  (let inr ((n n) (s 0))
    (if (zero? n) s (let-values (([q r] (quotient/remainder n 10))) (inr q (+ s r))))))

(define (smith-number? n)
  (and (not (prime? n))
       (= (sum-of-digits n)
          (for/sum ((pe (in-list (factorize n))))
            (* (cadr pe) (sum-of-digits (car pe)))))))

(module+ test
  (require rackunit)
  (check-equal? (sum-of-digits 0) 0)
  (check-equal? (sum-of-digits 33) 6)
  (check-equal? (sum-of-digits 30) 3)

  (check-true (smith-number? 166)))

(module+ main
  (let loop ((ns (filter smith-number? (range 1 (add1 10000)))))
    (unless (null? ns)
      (let-values (([l r] (split-at ns (min (length ns) 15))))
        (displayln l)
        (loop r)))))
