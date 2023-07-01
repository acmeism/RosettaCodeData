(de ** (X N)  # N th power of X
   (if (ge0 N)
      (let Y 1
         (loop
            (when (bit? 1 N)
               (setq Y (* Y X)) )
            (T (=0 (setq N (>> 1 N)))
               Y )
            (setq X (* X X)) ) )
      0 ) )
