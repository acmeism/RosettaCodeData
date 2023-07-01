(setq *Xprecision 3  *Yprecision 5)

(scl 7)
(mapc
   '((X Y)
      (prinl
         (round X *Xprecision)
         "  "
         (round Y *Yprecision) ) )
   (1.0 2.0 3.0)
   (1.0 1.414213562 1.732050807) )
