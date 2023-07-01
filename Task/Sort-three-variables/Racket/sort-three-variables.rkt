#lang racket

(define-syntax-rule (sort-3! x y z <?)
  (begin
    (define-syntax-rule (swap! x y) (let ((tmp x)) (set! x y) (set! y tmp)))
    (define-syntax-rule (sort-2! x y) (when (<? y x) (swap! x y)))
    (sort-2! x y)
    (sort-2! x z)
    (sort-2! y z)))

(module+ test
  (require rackunit
           data/order)

  (define (test-permutations l <?)
    (test-case
     (format "test-permutations ~a" (object-name <?))
     (for ((p (in-permutations l)))
       (match-define (list a b c) p)
       (sort-3! a b c <?)
       (check-equal? (list a b c) l))))

  (test-permutations '(1 2 3) <)

  ;; string sorting
  (let ((x  "lions, tigers, and")
        (y  "bears, oh my!")
        (z  "(from the \"Wizard of OZ\")"))
    (sort-3! x y z string<?)
    (for-each displayln (list x y z)))

  (newline)

  ;; general data sorting
  (define datum<? (order-<? datum-order))
  (let ((x  "lions, tigers, and")
        (y  "bears, oh my!")
        (z  '(from the "Wizard of OZ")))
    (sort-3! x y z datum<?)
    (for-each displayln (list x y z))))
