(de sparkLine (Lst)
   (let (Min (apply min Lst)  Max (apply max Lst)  Rng (- Max Min))
      (for N Lst
         (prin
            (char (+ 9601 (*/ (- N Min) 7 Rng)) ) ) )
      (prinl) ) )
