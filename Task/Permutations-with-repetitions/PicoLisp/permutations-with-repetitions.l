(de permrep (N Lst)
   (if (=0 N)
      (cons NIL)
      (mapcan
         '((X)
            (mapcar '((Y) (cons Y X)) Lst) )
         (permrep (dec N) Lst) ) ) )
