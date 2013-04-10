(load "@lib/frac.l")

(for (N 2  (> (** 2 19) N)  (inc N))
   (let (Sum (frac 1 N)  Lim (sqrt N))
      (for (F 2  (>= Lim F) (inc F))
         (when (=0 (% N F))
            (setq Sum
               (f+ Sum
                  (f+ (frac 1 F) (frac 1 (/ N F))) ) ) ) )
      (when (= 1 (cdr Sum))
         (prinl
            "Perfect " N
            ", sum is " (car Sum)
            (and (= 1 (car Sum)) ": perfect") ) ) ) )
