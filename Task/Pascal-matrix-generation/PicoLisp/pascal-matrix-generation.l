(setq
   Low '(A B)
   Upp '(B A)
   Sym '((+ A B) A) )

(de binomial (N K)
   (let f
      '((N)
         (if (=0 N) 1 (apply * (range 1 N))) )
      (if (> K N)
         0
         (/
            (f N)
            (* (f (- N K)) (f K)) ) ) ) )
(de pascal (N Z)
   (for Lst
      (mapcar
         '((A)
            (mapcar
               '((B) (apply binomial (mapcar eval Z)))
               (range 0 N) ) )
         (range 0 N) )
      (for L Lst
         (prin (align 2 L) " ") )
      (prinl) )
   (prinl) )

(pascal 4 Low)
(pascal 4 Upp)
(pascal 4 Sym)
