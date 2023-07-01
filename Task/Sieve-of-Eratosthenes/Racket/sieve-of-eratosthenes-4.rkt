#lang lazy
(define (ints-from i d) (cons i (ints-from (+ i d) d)))
(define (after n l f)
  (if (< (car l) n) (cons (car l) (after n (cdr l) f)) (f l)))
(define (diff l1 l2)
  (let ([x1 (car l1)] [x2 (car l2)])
    (cond [(< x1 x2) (cons x1 (diff (cdr l1)      l2 ))]
          [(> x1 x2)          (diff      l1  (cdr l2)) ]
          [else               (diff (cdr l1) (cdr l2)) ])))
(define (union l1 l2)        ; union of two lists
  (let ([x1 (car l1)] [x2 (car l2)])
    (cond [(< x1 x2) (cons x1 (union (cdr l1)      l2 ))]
          [(> x1 x2) (cons x2 (union      l1  (cdr l2)))]
          [else      (cons x1 (union (cdr l1) (cdr l2)))])))
