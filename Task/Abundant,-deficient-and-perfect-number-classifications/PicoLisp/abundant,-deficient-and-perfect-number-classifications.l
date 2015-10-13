(de accud (Var Key)
   (if (assoc Key (val Var))
      (con @ (inc (cdr @)))
      (push Var (cons Key 1)) )
   Key )
(de factor-sum (N)
   (if (=1 N)
      0
      (let
         (R NIL
            D 2
            L (1 2 2 . (4 2 4 2 4 6 2 6 .))
            M (sqrt N)
            N1 N
            S 1 )
         (while (>= M D)
            (if (=0 (% N1 D))
               (setq M
                  (sqrt (setq N1 (/ N1 (accud 'R D)))) )
               (inc 'D (pop 'L)) ) )
         (accud 'R N1)
         (for I R
            (one D)
            (one M)
            (for J (cdr I)
               (setq M (* M (car I)))
               (inc 'D M) )
               (setq S (* S D)) )
         (- S N) ) ) )
(bench
   (let
      (A 0
         D 0
         P 0 )
      (for I 20000
         (setq @@ (factor-sum I))
         (cond
            ((< @@ I) (inc 'D))
            ((= @@ I) (inc 'P))
            ((> @@ I) (inc 'A)) ) )
      (println D P A) ) )
(bye)
