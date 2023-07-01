(de longinc (Lst)
   (let (D NIL  R NIL)
      (for I Lst
         (cond
            ((< I (last D))
               (for (Y . X) D
                  (T (> X I) (set (nth D Y) I)) ) )
            ((< I (car R))
               (set R I)
               (when D (set (cdr R) (last D))) )
            (T (when R (queue 'D (car R)))
               (push 'R I) ) ) )
      (flip R) ) )
