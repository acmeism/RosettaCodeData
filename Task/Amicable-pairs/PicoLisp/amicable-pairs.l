(de accud (Var Key)
   (if (assoc Key (val Var))
      (con @ (inc (cdr @)))
      (push Var (cons Key 1)) )
   Key )
(de **sum (L)
   (let S 1
      (for I (cdr L)
         (inc 'S (** (car L) I)) )
      S ) )
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
            (setq S (* S (**sum I))) )
         (- S N) ) ) )
(bench
   (for I 20000
      (let X (factor-sum I)
         (and
            (< I X)
            (= I (factor-sum X))
            (println I X) ) ) ) )
