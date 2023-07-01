#lang racket
(require math/number-theory)
(define attractive? (compose1 prime? prime-omega))
(filter attractive? (range 1 121))
