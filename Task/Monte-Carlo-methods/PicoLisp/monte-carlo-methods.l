(de carloPi (Scl)
   (let (Dim (** 10 Scl)  Dim2 (* Dim Dim)  Pi 0)
      (do (* 4 Dim)
         (let (X (rand 0 Dim)  Y (rand 0 Dim))
            (when (>= Dim2 (+ (* X X) (* Y Y)))
               (inc 'Pi) ) ) )
      (format Pi Scl) ) )

(for N 6
   (prinl (carloPi N)) )
