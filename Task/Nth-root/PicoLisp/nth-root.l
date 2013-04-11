(load "@lib/math.l")

(de nthRoot (N A)
   (let (X1 A  X2 (*/ A N))
      (until (= X1 X2)
         (setq
            X1 X2
            X2 (*/
               (+
                  (* X1 (dec N))
                  (*/ A 1.0 (pow X1 (* (dec N) 1.0))) )
               N ) ) )
      X2 ) )

(prinl (format (nthroot 2  2.0) *Scl))
(prinl (format (nthroot 3 12.3) *Scl))
(prinl (format (nthroot 4 45.6) *Scl))
