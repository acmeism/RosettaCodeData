(de histogram (Pgm)
   (let H (need 256 0)
      (for L Pgm
         (for G L
            (inc (nth H (inc G))) ) )
      H ) )
