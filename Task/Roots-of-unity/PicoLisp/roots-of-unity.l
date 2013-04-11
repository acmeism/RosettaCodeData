(load "@lib/math.l")

(for N (range 2 10)
   (let Angle 0.0
      (prin N ": ")
      (for I N
         (let Ipart (sin Angle)
            (prin
               (round (cos Angle) 4)
               (if (lt0 Ipart) "-" "+")
               "j"
               (round (abs Ipart) 4)
               "  " ) )
         (inc 'Angle (*/ 2 pi N)) )
      (prinl) ) )
