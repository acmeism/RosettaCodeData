#lang racket/base
(require racket/list)

(define (perfect-shuffle l)
  (define-values (as bs) (split-at l (/ (length l) 2)))
  (foldr (λ (a b d) (list* a b d)) null as bs))

(define (perfect-shuffles-needed n)
  (define-values (_ rv)
    (for/fold ((d (perfect-shuffle (range n))) (i 1))
              ((_ (in-naturals))
               #:break (apply < d))
      (values (perfect-shuffle d) (add1 i))))
  rv)

(module+ test
  (require rackunit)
  (check-equal? (perfect-shuffle '(1 2 3 4)) '(1 3 2 4))

  (define (test-perfect-shuffles-needed n e)
    (define psn (perfect-shuffles-needed n))
    (printf "Deck size:\t~a\tShuffles needed:\t~a\t(~a)~%" n psn e)
    (check-equal? psn e))

  (for-each test-perfect-shuffles-needed
            '(8 24 52 100 1020 1024 10000)
            '(3 11  8  30 1018   10   300)))
