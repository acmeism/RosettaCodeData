#lang racket
(define a (read))
(unless (number? a) (error 'a+b "number" a))
(define b (read))
(unless (number? b) (error 'a+b "number" b))
(displayln (+ a b))
