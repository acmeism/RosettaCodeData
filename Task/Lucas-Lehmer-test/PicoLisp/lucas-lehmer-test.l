(de prime? (N)
   (or
      (= N 2)
      (and
         (> N 1)
         (bit? 1 N)
         (let S (sqrt N)
            (for (D 3  T  (+ D 2))
               (T (> D S) T)
               (T (=0 (% N D)) NIL) ) ) ) ) )

(de mersenne? (P)
   (or
      (= P 2)
      (let (MP (dec (>> (- P) 1))  S 4)
         (do (- P 2)
            (setq S (% (- (* S S) 2) MP)) )
         (=0 S) ) ) )
