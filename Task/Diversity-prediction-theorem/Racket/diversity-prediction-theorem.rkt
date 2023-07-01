#lang racket

(define (mean l)
  (/ (apply + l) (length l)))

(define (diversity-theorem truth predictions)
  (define μ (mean predictions))
  (define (avg-sq-diff a)
    (mean (map (λ (p) (sqr (- p a))) predictions)))
  (hash 'average-error (avg-sq-diff truth)
        'crowd-error (sqr (- truth μ))
        'diversity (avg-sq-diff μ)))

(println (diversity-theorem 49 '(48 47 51)))
(println (diversity-theorem 49 '(48 47 51 42)))
