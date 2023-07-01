(de quadruples (N)
   (let (AB NIL  S 3  R)
      (for A N
         (for (B A (>= N B) (inc B))
            (idx
               'AB
               (+ (* A A) (* B B))
               T ) ) )
      (for C N
         (let (S1 S  S2)
            (inc 'S 2)
            (setq S2 S)
            (for (D (+ C 1) (>= N D) (inc D))
               (and (idx 'AB S1) (idx 'R D T))
               (inc 'S1 S2)
               (inc 'S2 2) ) ) )
      (make
         (for A N
            (or (idx 'R A) (link A)) ) ) ) )

(println (quadruples 2200))
