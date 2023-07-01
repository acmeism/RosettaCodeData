(de distance (X1 Y1 X2 Y2)
   (**
      (+ (** (- X1 X2) 2.0) (** (- Y1 Y2) 2.0))
      0.5 ) )

(prinl "Distance: "
   (unc
      (distance
         (unc 100. 1.1)
         (unc 50. 1.2)
         (unc 200. 2.2)
         (unc 100. 2.3) ) ) )
