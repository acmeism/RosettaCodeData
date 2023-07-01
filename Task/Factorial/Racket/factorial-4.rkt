(define (factorial n)
  (for/product ([i (in-range 1 (+ n 1))]) i))
