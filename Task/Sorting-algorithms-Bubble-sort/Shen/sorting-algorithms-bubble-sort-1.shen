(tc +)

(define swap
  { (vector number) --> number --> number --> (vector number) }
  A I1 I2 -> (let Z (<-vector A I1)
               (do (vector-> A I1 (<-vector A I2))
                   (vector-> A I2 Z))))

(define one-pass
  { (vector number) --> number --> boolean --> number --> boolean }
  A N Swapped N -> (do (if (> (<-vector A (- N 1)) (<-vector A N))
                           (swap A (- N 1) N))
                       Swapped)
  A N Swapped I -> (if (> (<-vector A (- I 1)) (<-vector A I))
                       (do (swap A (- I 1) I)
                           (one-pass A N true (+ I 1)))
                       (one-pass A N Swapped (+ I 1))))

(define bubble-h
  { boolean --> (vector number) --> number --> (vector number) }
  true A N -> (bubble-h (one-pass A N false 2) A N)
  false A N -> A)

(define bubble-sort
  { (vector number) --> (vector number) }
  A -> (let N (limit A)
         (bubble-h (one-pass A N false 2) A N)))
