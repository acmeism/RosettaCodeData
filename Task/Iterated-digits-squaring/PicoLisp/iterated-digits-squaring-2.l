(let Ones 0
   (for I 100000000
      (and (=1 (1or89 I)) (inc 'Ones)) )
   (println (- 100000000 Ones)) )
