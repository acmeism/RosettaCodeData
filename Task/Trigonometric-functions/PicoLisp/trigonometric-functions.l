(load "@lib/math.l")

(de dtor (Deg)
   (*/ Deg pi 180.0) )

(de rtod (Rad)
   (*/ Rad 180.0 pi) )

(prinl
   (format (sin (/ pi 4)) *Scl) " " (format (sin (dtor 45.0)) *Scl) )
(prinl
   (format (cos (/ pi 4)) *Scl) " " (format (cos (dtor 45.0)) *Scl) )
(prinl
   (format (tan (/ pi 4)) *Scl) " " (format (tan (dtor 45.0)) *Scl) )
(prinl
   (format (asin (sin (/ pi 4))) *Scl) " " (format (rtod (asin (sin (dtor 45.0)))) *Scl) )
(prinl
   (format (acos (cos (/ pi 4))) *Scl) " " (format (rtod (acos (cos (dtor 45.0)))) *Scl) )
(prinl
   (format (atan (tan (/ pi 4))) *Scl) " " (format (rtod (atan (tan (dtor 45.0)))) *Scl) )
