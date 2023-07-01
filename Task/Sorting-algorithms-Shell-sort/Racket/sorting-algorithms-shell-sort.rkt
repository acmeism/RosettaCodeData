#lang racket
(define (shell-sort! xs)
  (define ref (curry vector-ref xs))
  (define (new Δ) (if (= Δ 2) 1 (quotient (* Δ 5) 11)))
  (let loop ([Δ (quotient (vector-length xs) 2)])
    (unless (= Δ 0)
      (for ([xᵢ (in-vector xs)] [i (in-naturals)])
        (let while ([i i])
          (cond [(and (>= i Δ) (> (ref (- i Δ)) xᵢ))
                 (vector-set! xs i (ref (- i Δ)))
                 (while (- i Δ))]
                [else (vector-set! xs i xᵢ)])))
      (loop (new Δ))))
  xs)
