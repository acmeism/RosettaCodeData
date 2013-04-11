(load "@lib/simul.l")

(de spiral (N)
   (prog1 (grid N N)
      (let (Dir '(north east south west .)  This 'a1)
         (for Val (* N N)
            (=: val Val)
            (setq This
               (or
                  (with ((car Dir) This)
                     (unless (: val) This) )
                  (with ((car (setq Dir (cdr Dir))) This)
                     (unless (: val) This) ) ) ) ) ) ) )

(mapc
   '((L)
      (for This L (prin (align 3 (: val))))
      (prinl) )
   (spiral 5) )
