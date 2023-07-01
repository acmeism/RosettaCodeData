(zero *BsdSeed *MsSeed)

(de bsdRand ()
   (setq *BsdSeed
      (& (+ 12345 (* 1103515245 *BsdSeed)) `(dec (** 2 31))) ) )

(de msRand ()
   (>> 16
      (setq *MsSeed
         (& (+ 2531011 (* 214013 *MsSeed)) `(dec (** 2 31))) ) ) )
