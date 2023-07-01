#lang racket

(define solution? (match-lambda [(list a b c d e f g) (= (+ a b) (+ b c d) (+ d e f) (+ f g))]))

(define (fold-4-rings-or-4-squares-puzzle lo hi kons k0)
  (for*/fold ((k k0))
            ((combination (in-combinations (range lo (add1 hi)) 7))
             (permutation (in-permutations combination))
             #:when (solution? permutation))
            (kons permutation k)))

(fold-4-rings-or-4-squares-puzzle 1 7 cons null)
(fold-4-rings-or-4-squares-puzzle 3 9 cons null)
(fold-4-rings-or-4-squares-puzzle 0 9 (λ (ignored-solution count) (add1 count)) 0)
