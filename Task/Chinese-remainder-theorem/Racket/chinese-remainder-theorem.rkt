#lang racket
(require (only-in math/number-theory solve-chinese))
(define as '(2 3 2))
(define ns '(3 5 7))
(solve-chinese as ns)
