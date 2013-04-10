(load "@lib/math.l")

(de meanAngle (Lst)
   (*/
      (atan2
         (sum '((A) (sin (*/ A pi 180.0))) Lst)
         (sum '((A) (cos (*/ A pi 180.0))) Lst) )
      180.0 pi ) )

(for L '((350.0 10.0) (90.0 180.0 270.0 360.0) (10.0 20.0 30.0))
   (prinl
      "The mean angle of ["
      (glue ", " (mapcar round L '(0 .)))
      "] is: " (round (meanAngle L))) )
