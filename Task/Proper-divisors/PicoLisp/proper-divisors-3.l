(de accu1 (Var Key)
   (if (assoc Key (val Var))
      (con @ (inc (cdr @)))
      (push Var (cons Key 2)) )
   Key )
(de factor (N)
   (let
      (R NIL
         D 2
         L (1 2 2 . (4 2 4 2 4 6 2 6 .))
         M (sqrt N) )
      (while (>= M D)
         (if (=0 (% N D))
            (setq M
               (sqrt (setq N (/ N (accu1 'R D)))) )
            (inc 'D (pop 'L)) ) )
      (accu1 'R N)
      (dec (apply * (mapcar cdr R))) ) )
(bench
   (println
      (maxi
         factor
         (range 1 20000) )
      @@ ) )
