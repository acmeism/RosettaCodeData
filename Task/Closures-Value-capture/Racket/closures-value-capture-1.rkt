#lang racket
(define functions (for/list ([i 10]) (λ() (* i i))))
(map (λ(f) (f)) functions)
