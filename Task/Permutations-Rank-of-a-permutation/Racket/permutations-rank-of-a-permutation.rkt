#lang racket (require math)
(define-syntax def (make-rename-transformer #'match-define-values))

(define (perm xs n)
  (cond [(empty? xs) '()]
        [else (def (q r) (quotient/remainder n (factorial (sub1 (length xs)))))
              (def (a (cons c b)) (split-at xs q))
              (cons c (perm (append a b) r))]))

(define (rank ys)
  (cond [(empty? ys) 0]
        [else (def ((cons x0 xs)) ys)
              (+ (rank xs)
                 (* (for/sum ([x xs] #:when (< x x0)) 1)
                    (factorial (length xs))))]))
