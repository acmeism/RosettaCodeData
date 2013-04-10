(de halve (N)
   (/ N 2) )

(de double (N)
   (* N 2) )

(de even? (N)
   (not (bit? 1 N)) )

(de ethiopian (X Y)
   (let R 0
      (while (>= X 1)
         (or (even? X) (inc 'R Y))
         (setq
            X (halve X)
            Y (double Y) ) )
      R ) )
