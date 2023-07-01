(scl 6)

(de vdc (N B)
   (default B 2)
   (let (R 0  A 1.0)
      (until (=0 N)
         (inc 'R (* (setq A (/ A B)) (% N B)))
         (setq N (/ N B)) )
      R ) )

(for B (2 3 4)
   (prinl "Base: " B)
   (for N (range 0 9)
      (prinl N ": " (round (vdc N B) 4)) ) )
