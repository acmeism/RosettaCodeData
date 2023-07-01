(load "@lib/math.l")

(de meanTime (Lst)
   (let Tim
      (*/
         (atan2
            (sum '((S) (sin (*/ ($tim S) pi 43200))) Lst)
            (sum '((S) (cos (*/ ($tim S) pi 43200))) Lst) )
         43200 pi )
      (tim$ (% (+ Tim 86400) 86400) T) ) )
