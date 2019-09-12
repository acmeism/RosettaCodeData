(def fib
  (memoize
    (fn [n]
      (case n
        0 0
        1 1
        (+ (fib (- n 1))
           (fib (- n 2)))))))
