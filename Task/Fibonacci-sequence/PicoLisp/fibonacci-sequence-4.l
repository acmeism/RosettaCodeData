(de fibo (N)
   (let (I 1 J 0)
      (do N
         (let (Tmp J)
            (inc 'J I)
            (setq I Tmp) ) )
      J) )
