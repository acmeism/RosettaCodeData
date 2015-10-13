(de perfect (N)
   (let C 0
      (for I (/ N 2)
         (and (=0 (% N I)) (inc 'C I)) )
      (= C N) ) )
