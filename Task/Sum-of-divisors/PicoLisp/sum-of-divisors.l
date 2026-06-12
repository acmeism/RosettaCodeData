(de propdiv (N)
   (let S 0
      (for X N
         (and (=0 (% N X)) (inc 'S X)) )
      S ) )
(do 10
   (do 10
      (prin (align 4 (propdiv (inc (0))))) )
      (prinl) )
