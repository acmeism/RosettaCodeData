(de fibo (N)
   (if (lt0 N)
      (quit "Illegal argument" N) )
   (recur (N)
      (if (> 2 N)
         1
         (+ (recurse (dec N)) (recurse (- N 2))) ) ) )
