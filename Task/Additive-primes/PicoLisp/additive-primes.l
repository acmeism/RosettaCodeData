(de prime? (N)
   (let D 0
      (or
         (= N 2)
         (and
            (> N 1)
            (bit? 1 N)
            (for (D 3  T  (+ D 2))
               (T (> D (sqrt N)) T)
               (T (=0 (% N D)) NIL) ) ) ) ) )
(de additive (N)
   (and
      (prime? N)
      (prime? (sum format (chop N))) ) )
(let C 0
   (for (N 0 (> 500 N) (inc N))
      (when (additive N)
         (printsp N)
         (inc 'C) ) )
   (prinl)
   (prinl "Total count: " C) )
