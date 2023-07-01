#lang racket

(struct ->  (A B))
(struct ->. (A B))

(define ((Markov-algorithm . rules) initial-string)
  (let/cc stop
    ; rewriting rules
    (define (rewrite rule str)
      (match rule
        [(->  a b) (cond [(replace a str b) => apply-rules]
                         [else str])]
        [(->. a b) (cond [(replace a str b) => stop]
                         [else str])]))
    ; the cycle through rewriting rules
    (define (apply-rules s) (foldl rewrite s rules))
    ; the result is a fixed point of rewriting procedure
    (fixed-point apply-rules initial-string)))

;; replaces the first substring A to B in a string s
(define (replace A s B)
  (and (regexp-match? (regexp-quote A) s)
       (regexp-replace (regexp-quote A) s B)))

;; Finds the least fixed-point of a function
(define (fixed-point f x0)
  (let loop ([x x0] [fx (f x0)])
    (if (equal? x fx) fx (loop fx (f fx)))))
