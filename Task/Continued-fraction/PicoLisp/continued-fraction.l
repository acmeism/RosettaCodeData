(scl 49)
(de fsqrt2 (N A)
   (default A 1)
   (cond
      ((> A (inc N)) 2)
      (T
         (+
            (if (=1 A) 1.0 2.0)
            (*/ `(* 1.0 1.0) (fsqrt2 N (inc A))) ) ) ) )
(de pi (N A)
   (default A 1)
   (cond
      ((> A (inc N)) 6.0)
      (T
         (+
            (if (=1 A) 3.0 6.0)
            (*/
               (* (** (dec (* 2 A)) 2) 1.0)
               1.0
               (pi N (inc A)) ) ) ) ) )
(de napier (N A)
   (default A 0)
   (cond
      ((> A N) (* A 1.0))
      (T
         (+
            (if (=0 A) 2.0 (* A 1.0))
            (*/
               (if (> 1 A) 1.0 (* A 1.0))
               1.0
               (napier N (inc A)) ) ) ) ) )
(prinl (format (fsqrt2 200) *Scl))
(prinl (format (napier 200) *Scl))
(prinl (format (pi 200) *Scl))
