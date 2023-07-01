(de ternary (N)
   (if (=0 N)
      (cons N)
      (make
         (while (gt0 N)
            (yoke (% (swap 'N (/ N 3)) 3)) ) ) ) )
(de p? (L1 L2)
   (and
      (= L1 (reverse L1))
      (= L2 (reverse L2)) ) )

(zero N)
(for (I 0 (> 6 I))
   (let (B2 (chop (bin N))  B3 (ternary N))
      (when (p? B2 B3)
         (println N (pack B2) (pack B3))
         (inc 'I) )
      (inc 'N) ) )
