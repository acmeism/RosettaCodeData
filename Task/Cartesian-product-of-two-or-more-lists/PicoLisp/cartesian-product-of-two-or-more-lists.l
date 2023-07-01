(de 2lists (L1 L2)
   (mapcan
      '((I)
         (mapcar
            '((A) ((if (atom A) list cons) I A))
            L2 ) )
      L1 ) )
(de reduce (L . @)
   (ifn (rest) L (2lists L (apply reduce (rest)))) )
(de cartesian (L . @)
   (and L (rest) (pass reduce L)) )

(println
   (cartesian (1 2)) )
(println
   (cartesian NIL (1 2)) )
(println
   (cartesian (1 2) (3 4)) )
(println
   (cartesian (3 4) (1 2)) )
(println
   (cartesian (1776 1789) (7 12) (4 14 23) (0 1)) )
(println
   (cartesian (1 2 3) (30) (500 100)) )
(println
   (cartesian (1 2 3) NIL (500 100)) )
