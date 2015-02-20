#lang racket
(map (λ(f) (f))
     (for/list ([i 10]) (λ () (* i i))))
