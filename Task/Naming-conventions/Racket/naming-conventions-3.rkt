#lang racket
(struct pair (x y) #:transparent #:mutable)
(define p (pair 1 2))
(pair-x p)    ; ==> 1
(set-pair-y! p 3)
p    ; ==> (pair 1 3)
