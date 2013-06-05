#lang racket

(define (merge-sort xs)
  (merge* (map list xs)))

(define (merge* xss)
  (match xss
    [(list)    '()]
    [(list xs) xss]
    [(list xs ys zss ...)
     (merge* (cons (merge xs ys) (merge* zss)))]))

(define (merge xs ys)
  (cond [(empty? xs) ys]
        [(empty? ys) xs]
        [(match* (xs ys)
           [((list* a as) (list* b bs))
            (cond [(<= a b) (cons a (merge as ys))]
                  [         (cons b (merge xs bs))])])]))
