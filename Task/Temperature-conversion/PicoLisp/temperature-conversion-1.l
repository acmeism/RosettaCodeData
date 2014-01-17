(scl 2)

(de convertKelvin (Kelvin)
   (for X
      (quote
         (K . prog)
         (C (K) (- K 273.15))
         (F (K) (- (*/ K 1.8 1.0) 459.67))
         (R (K) (*/ K 1.8 1.0)) )
      (tab (-3 8)
         (car X)
         (format ((cdr X) Kelvin) *Scl) ) ) )
