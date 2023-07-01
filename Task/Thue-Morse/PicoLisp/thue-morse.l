(let R 0
   (prinl R)
   (for (X 1 (>= 32 X))
      (setq R
         (bin
            (pack
               (bin R)
               (bin (x| (dec (** 2 X)) R)) ) ) )
      (prinl (pack 0 (bin R)))
      (inc 'X X) ) )
