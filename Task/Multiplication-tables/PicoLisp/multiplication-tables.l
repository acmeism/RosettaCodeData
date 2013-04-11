(de mulTable (N)
   (space 4)
   (for X N
      (prin (align 4 X)) )
   (prinl)
   (prinl)
   (for Y N
      (prin (align 4 Y))
      (space (* (dec Y) 4))
      (for (X Y (>= N X) (inc X))
         (prin (align 4 (* X Y))) )
      (prinl) ) )

(mulTable 12)
