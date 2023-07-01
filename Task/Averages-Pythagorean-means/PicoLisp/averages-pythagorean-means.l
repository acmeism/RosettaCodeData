(load "@lib/math.l")

(let (Lst (1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0)  Len (length Lst))
   (prinl "Arithmetic mean: "
      (format
         (/ (apply + Lst) Len)
         *Scl ) )
   (prinl "Geometric mean: "
      (format
         (pow (*/ (apply * Lst) (** 1.0 (dec Len))) (/ 1.0 Len))
         *Scl ) )
   (prinl "Harmonic mean: "
      (format
         (*/ (* 1.0 Len) 1.0 (sum '((N) (*/ 1.0 1.0 N)) Lst))
         *Scl ) ) )
