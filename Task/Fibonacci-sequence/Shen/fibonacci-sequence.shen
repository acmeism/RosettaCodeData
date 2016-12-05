(define fib
  0 -> 0
  1 -> 1
  N -> (+ (fib (+ N 1)) (fib (+ N 2)))
       where (< N 0)
  N -> (+ (fib (- N 1)) (fib (- N 2))))
