#lang racket

(module same-fringe lazy
  (provide same-fringe?)
  (define (same-fringe? t1 t2)
    (! (equal? (flatten t1) (flatten t2))))
  (define (flatten tree)
    (if (list? tree)
      (apply append (map flatten tree))
      (list tree))))

(require 'same-fringe)

(module+ test
  (require rackunit)
  (check-true (same-fringe? '((1 2 3) ((4 5 6) (7 8)))
                            '(((1 2 3) (4 5 6)) (7 8))))
  (check-false (same-fringe? '((1 2 3) ((4 5 6) (7 8)))
                             '(((1 2 3) (4 6)) (8)))))
