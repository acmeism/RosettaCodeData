(scl 6)

(de jensen (I Lo Hi Term)
   (let Temp 0
      (set I Lo)
      (while (>= Hi (val I))
         (inc 'Temp (Term))
         (inc I) )
      Temp ) )

(let I (box)  # Create indirect reference
   (format
      (jensen I 1 100 '(() (*/ 1.0 (val I))))
      *Scl ) )
