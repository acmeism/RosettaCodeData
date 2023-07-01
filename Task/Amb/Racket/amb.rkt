#lang racket

;; A quick `amb' implementation (same as in the Twelve Statements task)
(define failures null)

(define (fail)
  (if (pair? failures) ((first failures)) (error "no more choices!")))

(define (amb/thunks choices)
  (let/cc k (set! failures (cons k failures)))
  (if (pair? choices)
    (let ([choice (first choices)]) (set! choices (rest choices)) (choice))
    (begin (set! failures (rest failures)) (fail))))

(define-syntax-rule (amb E ...) (amb/thunks (list (lambda () E) ...)))

(define (assert condition) (unless condition (fail)))

;; Problem solution

(define (joins? left right)
  (regexp-match? #px"(.)\0\\1" (~a left "\0" right)))

(let ([result (list (amb "the" "that" "a")
                    (amb "frog" "elephant" "thing")
                    (amb "walked" "treaded" "grows")
                    (amb "slowly" "quickly"))])
  (for ([x result] [y (cdr result)]) (assert (joins? x y)))
  result)
;; -> '("that" "thing" "grows" "slowly")
