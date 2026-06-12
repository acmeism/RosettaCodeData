#lang racket/base

(define (rev l (acc null))
    (if (null? l)
        acc
        (rev (cdr l) (cons (car l) acc))))

(define (++ l m)
    (if (null? l)
        m
        (let recur ((l-rev (rev l)) (acc m))
          (if (null? l-rev)
              acc
              (recur (cdr l-rev) (cons (car l-rev) acc))))))

(define (remove-at l i (acc null))
  (cond
    [(null? l) (rev acc)]
    [(positive? i) (remove-at (cdr l) (sub1 i) (cons (car l) acc))]
    [else (++ (rev acc) (cdr l))]))

(displayln (remove-at '(1 2 3) 0))
(displayln (remove-at '(1 2 3) 1))
(displayln (remove-at '(1 2 3) 2))
(displayln (remove-at '(1 2 3) 3))
