(de binomial (N K)
   (let f
      '((N)
         (if (=0 N) 1 (apply * (range 1 N))) )
      (/
         (f N)
         (* (f (- N K)) (f K)) ) ) )
