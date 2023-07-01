#lang racket
(require math)
(define C binomial)
(define P permutations)

(C 1000 10) ; -> 263409560461970212832400
(P 1000 10) ; -> 955860613004397508326213120000
