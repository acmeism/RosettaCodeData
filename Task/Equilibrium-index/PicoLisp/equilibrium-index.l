(de equilibria (Lst)
   (make
      (let Sum 0
         (for ((I . L) Lst L (cdr L))
            (and (= Sum (sum prog (cdr L))) (link I))
            (inc 'Sum (car L)) ) ) ) )
