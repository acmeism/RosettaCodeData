#lang racket

(define N 17)

(define (dist i j)
  (define d (abs (- i j)))
  (if (<= d (quotient N 2)) d (- N d)))

(define v
  (build-vector N
    (λ(i) (build-vector N
            (λ(j) (case (dist i j) [(0) '-] [(1 2 4 8) 1] [else 0]))))))

(for ([row v]) (displayln row))
