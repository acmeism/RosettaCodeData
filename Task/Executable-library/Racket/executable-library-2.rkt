#lang racket
(require "hs.rkt")
(define N 100000)
(define t (make-hasheq))
(define best
  (for/fold ([best #f]) ([i (in-range 1 (add1 N))])
    (define len (length (hailstone i)))
    (define freq (add1 (hash-ref t len 0)))
    (hash-set! t len freq)
    (if (and best (> (car best) freq)) best (cons freq len))))
(printf "Most frequent sequence length for x<=~s: ~s, appearing ~s times\n" N
        (cdr best) (car best))
