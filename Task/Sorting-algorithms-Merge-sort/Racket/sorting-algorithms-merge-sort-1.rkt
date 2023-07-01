#lang racket

(define (merge xs ys)
  (cond [(empty? xs) ys]
        [(empty? ys) xs]
        [(match* (xs ys)
           [((list* a as) (list* b bs))
            (cond [(<= a b) (cons a (merge as ys))]
                  [         (cons b (merge xs bs))])])]))

(define (merge-sort xs)
  (match xs
    [(or (list) (list _)) xs]
    [_ (define-values (ys zs) (split-at xs (quotient (length xs) 2)))
       (merge (merge-sort ys) (merge-sort zs))]))
