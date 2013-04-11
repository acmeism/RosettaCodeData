(de **Mod (X Y N)
   (let M 1
      (loop
         (when (bit? 1 Y)
            (setq M (% (* M X) N)) )
         (T (=0 (setq Y (>> 1 Y)))
            M )
         (setq X (% (* X X) N)) ) ) )

(de prime? (N)
   (or
      (= N 2)
      (and
         (> N 1)
         (bit? 1 N)
         (for (D 3  T  (+ D 2))
            (T (> D (sqrt N)) T)
            (T (=0 (% N D)) NIL) ) ) ) )

(de mFactor (P)
   (let (Lim (sqrt (dec (** 2 P)))  K 0  Q)
      (loop
         (setq Q (inc (* 2 (inc 'K) P)))
         (T (>= Q Lim) NIL)
         (T
            (and
               (member (% Q 8) (1 7))
               (prime? Q)
               (= 1 (**Mod 2 P Q)) )
            Q ) ) ) )
