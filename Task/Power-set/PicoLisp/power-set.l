(de powerset (Lst)
   (ifn Lst
      (cons)
      (let L (powerset (cdr Lst))
         (conc
            (mapcar '((X) (cons (car Lst) X)) L)
            L ) ) ) )
