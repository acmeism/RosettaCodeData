(de fib (N)
   (let (A 0  B 1)
      (do N
         (prog1 B (setq B (+ A B) A @)) ) ) )
