#lang racket

(define/contract x
  (=/c 42) ; make sure x = 42
  42)

(define/contract f
  (-> number? (or/c 'yes 'no)) ; function contract
  (lambda (x)
    (if (= 42 x) 'yes 'no)))

(f 42)    ; succeeds
(f "foo") ; contract error!
