(de prime? (N)
   (or
      (= N 2)
      (and
         (> N 1)
         (bit? 1 N)
         (for (D 3  T  (+ D 2))
            (T (> D (sqrt N)) T)
            (T (=0 (% N D)) NIL) ) ) ) )
(let
   (D 2
      L (1 2 2 . (4 2 4 2 4 6 2 6 .))
      Lst
      (make
         (while (>= 23456789 D)
            (and
               (prime? D)
               (apply < (chop D))
               (link D) )
            (inc 'D (++ L)) ) ) )
   (let Fmt (need 10 10)
      (while (cut 10 'Lst)
         (apply tab @ Fmt) ) ) )
