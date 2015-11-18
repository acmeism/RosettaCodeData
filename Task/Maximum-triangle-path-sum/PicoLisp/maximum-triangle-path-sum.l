(de maxpath (Lst)
   (let (Lst (reverse Lst)  R (car Lst))
      (for I (cdr Lst)
         (setq R
            (mapcar
               +
               (maplist
                  '((L)
                     (and (cdr L) (max (car L) (cadr L))) )
                  R )
               I ) ) )
      (car R) ) )
