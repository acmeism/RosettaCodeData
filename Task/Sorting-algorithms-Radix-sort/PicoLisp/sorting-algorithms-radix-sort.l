(de radixSort (Lst)
   (let Mask 1
      (while
         (let (Pos (list NIL NIL)  Neg (list NIL NIL)  Flg)
            (for N Lst
               (queue
                  (if2 (ge0 N) (bit? Mask N)
                     (cdr Pos) Pos Neg (cdr Neg) )
                  N )
               (and (>= (abs N) Mask) (on Flg)) )
            (setq
               Lst (conc (apply conc Neg) (apply conc Pos))
               Mask (* 2 Mask) )
            Flg ) ) )
   Lst )
