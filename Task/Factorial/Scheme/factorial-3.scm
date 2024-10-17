(define (factorial n)
  (do ((i 1 (+ i 1))
       (accum 1 (* accum i)))
      ((> i n) accum)))
