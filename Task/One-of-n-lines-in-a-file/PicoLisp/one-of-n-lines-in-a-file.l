(de one-of-n (N)
   (let R 1
      (for I N
         (when (= 1 (rand 1 I))
            (setq R I) ) )
      R ) )

(let L (need 10 0)
   (do 1000000
      (inc (nth L (one-of-n 10))) )
   L )
