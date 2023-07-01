(de fibo (N)
   (cache '(NIL) N  # Use a cache to accelerate
      (if (>= 2 N)
         N
         (+ (fibo (dec N)) (fibo (- N 2))) ) ) )

(bench (fibo 1000))
