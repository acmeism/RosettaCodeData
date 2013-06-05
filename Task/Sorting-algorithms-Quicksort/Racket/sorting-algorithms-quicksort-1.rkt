#lang racket
(define (quicksort a-list (compare <))
  (match a-list
    ((list)
     (list))
    ((cons x xs)
     (append (quicksort (filter (lambda (element) (compare element x)) xs) compare)
             (list x)
             (quicksort (filter (lambda (element) (not (compare element x))) xs) compare)))))
