#lang racket

;; Racket's max and min allow inexact numbers to contaminate exact numbers
;; Use argmax and argmin instead, as they don't have this problem

(define (max . xs) (argmax identity xs))
(define (min . xs) (argmin identity xs))

;; a bag is a list of disjoint intervals

(define ((irrelevant? x y) item) (or (< (second item) x) (> (first item) y)))

(define (insert bag x y)
  (define-values (irrelevant relevant) (partition (irrelevant? x y) bag))
  (cons (list (apply min x (map first relevant))
              (apply max y (map second relevant))) irrelevant))

(define (solve xs)
  (sort (for/fold ([bag '()]) ([x (in-list xs)])
          (insert bag (apply min x) (apply max x))) < #:key first))

(define inputs '(([1.1 2.2])
                 ([6.1 7.2] [7.2 8.3])
                 ([4 3] [2 1])
                 ([4 3] [2 1] [-1 -2] [3.9 10])
                 ([1 3] [-6 -1] [-4 -5] [8 2] [-6 -6])))

(for ([xs (in-list inputs)]) (printf "~a => ~a\n" xs (solve xs)))
