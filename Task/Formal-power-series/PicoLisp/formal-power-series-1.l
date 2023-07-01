(de lazy Args
   (def (car Args)
      (list (cadr Args)
         (cons 'cache (lit (cons))
            (caadr Args)
            (cddr Args) ) ) ) )
