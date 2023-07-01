(de ncsubseq (Lst)
   (let S 0
      (recur (S Lst)
         (ifn Lst
            (and (>= S 3) '(NIL))
            (let (X (car Lst)  XS (cdr Lst))
               (ifn (bit? 1 S)  # even
                  (conc
                     (mapcar '((YS) (cons X YS))
                        (recurse (inc S) XS) )
                     (recurse S XS) )
                  (conc
                     (mapcar '((YS) (cons X YS))
                        (recurse S XS) )
                     (recurse (inc S) XS) ) ) ) ) ) ) )
