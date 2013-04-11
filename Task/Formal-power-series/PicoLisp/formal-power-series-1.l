(de lazy Args
   (def (car Args)
      (list (cadr Args)
         (cons 'cache (lit (cons))
            (list 'pack (list 'char (list 'hash (caadr Args))) (caadr Args))
            (cddr Args) ) ) ) )
