(load "@lib/misc.l")

(scl 25)

(setq LN2 0.69314718055994530941723212)

(de almost-int? (N)
   (bool (member (% (/ N 0.1) 10) (0 9))))

(de fmt4 (N)
   (format (/ N 0.0001) 4))

(de h (N)
   (*/ (factorial N) `(* 1.0 1.0) (* 2 (s** LN2 (inc N)))))

(de s** (A N)  # scaled integer exponentiation
   (let R 1.0
      (for Bit (chop (bin N))
         (setq R (*/ R R 1.0))
         (when (= Bit "1")
            (setq R (*/ A R 1.0))))
      R))

(de factorial (N)
   (cond
      ((lt0 N)   NIL)
      ((=0 N)    1)
      (T         (apply * (range 1 N)))))

(for I 18
   (let H (h I)
      (if (almost-int? H)
         (prin "yes: ")
         (prin " no: "))
      (prinl "h(" (align 2 I) ") = " (fmt4 H))))
(bye)
