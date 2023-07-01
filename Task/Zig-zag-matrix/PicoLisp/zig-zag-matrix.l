(load "@lib/simul.l")

(de zigzag (N)
   (prog1 (grid N N)
      (let (D '(north west  south east  .)  E '(north east .)  This 'a1)
         (for Val (* N N)
            (=: val Val)
            (setq This
               (or
                  ((cadr D) ((car D) This))
                  (prog
                     (setq D (cddr D))
                     ((pop 'E) This) )
                  ((pop 'E) This) ) ) ) ) ) )

(mapc
   '((L)
      (for This L (prin (align 3 (: val))))
      (prinl) )
   (zigzag 5) )
