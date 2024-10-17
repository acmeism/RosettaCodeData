(define (factorial n)
  (let loop ((i 1)
             (accum 1))
    (if (> i n)
        accum
        (loop (+ i 1) (* accum i)))))
