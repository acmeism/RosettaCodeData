(for N (range 3 6)
   (tab (2 1 7 2 7 2)
      N ":"
      (format
         (let S 0 (do 10000 (inc 'S (randN N))))
         2 )
      "%"
      (format
         (let S 0 (do 10000 (inc 'S (unbiased N))))
         2 )
      "%" ) )
