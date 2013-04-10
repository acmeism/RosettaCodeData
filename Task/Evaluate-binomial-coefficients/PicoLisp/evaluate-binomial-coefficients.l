(de binomial (N K)
   (let f '((N) (apply * (range 1 N)))
      (/ (f N) (* (f (- N K)) (f K))) ) )
