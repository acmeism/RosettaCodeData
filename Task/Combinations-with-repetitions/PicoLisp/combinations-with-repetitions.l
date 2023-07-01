(de combrep (N Lst)
   (cond
      ((=0 N) '(NIL))
      ((not Lst))
      (T
         (conc
            (mapcar
               '((X) (cons (car Lst) X))
               (combrep (dec N) Lst) )
            (combrep N (cdr Lst)) ) ) ) )
