(de fibo (N)
   (if (>= 2 N)
      1
      (+ (fibo (dec N)) (fibo (- N 2))) ) )
