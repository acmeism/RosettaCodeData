(de splitme (Str)
   (let (Str (chop Str)  Fin)
      (glue
         ", "
         (make
            (for X Str
               (if (= X (car Fin))
                  (conc Fin (cons X))
                  (link (setq Fin (cons X))) ) ) ) ) ) )
(prinl (splitme "gHHH5YY++///\\"))
