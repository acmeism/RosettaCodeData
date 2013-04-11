(scl 1)

(de mapRange (Val A1 A2 B1 B2)
   (+ B1 (*/ (- Val A1) (- B2 B1) (- A2 A1))) )


(for Val (range 0 10.0 1.0)
   (prinl
      (format (mapRange Val 0 10.0 -1.0 0) *Scl) ) )
