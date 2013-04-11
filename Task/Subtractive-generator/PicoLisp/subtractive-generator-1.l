(setq
   *Bentley (apply circ (need 55))
   *Bentley2 (nth *Bentley 32) )

(de subRandSeed (S)
   (let (N 1  P (nth *Bentley 55))
      (set P S)
      (do 54
         (set (setq P (nth P 35)) N)
         (when (lt0 (setq N (- S N)))
            (inc 'N 1000000000) )
         (setq S (car P)) ) )
   (do 165 (subRand)) )

(de subRand ()
   (when (lt0 (dec *Bentley (pop '*Bentley2)))
      (inc *Bentley 1000000000) )
   (pop '*Bentley) )
