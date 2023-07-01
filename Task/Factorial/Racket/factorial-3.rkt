(define (factorial n)
  (for/fold ([pro 1]) ([i (in-range 1 (+ n 1))]) (* pro i)))
