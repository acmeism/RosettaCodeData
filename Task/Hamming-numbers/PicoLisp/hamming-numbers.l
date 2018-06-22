(de hamming (N)
   (let (L (1)  H)
      (do N
         (for (X L X (cadr X))      # Find smallest result
            (setq H (car X)) )
         (idx 'L H NIL)             # Remove it
         (for I (2 3 5)             # Generate next results
            (idx 'L (* I H) T) ) )
      H ) )

(println (make (for N 20 (link (hamming N)))))
(println (hamming 1691))   # very fast
(println (hamming 1000000))   # runtime about 13 minutes on i5-3570S
