(de mean (Lst)
   (if (atom Lst)
      0
      (/ (apply + Lst) (length Lst)) ) )
