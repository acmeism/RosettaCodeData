#lang racket
(define (stack) '())
(define (push x stack) (cons x stack))
(define (pop stack) (values (car stack) (cdr stack)))
(define (empty? stack) (null? stack))
