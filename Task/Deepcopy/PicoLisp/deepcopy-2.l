(de deepCopy (X)
   (if (atom X)
      X
      (cons (deepCopy (car X)) (deepCopy (cdr X))) ) )
