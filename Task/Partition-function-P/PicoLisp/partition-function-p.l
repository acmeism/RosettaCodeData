(de gpentagonals (Max)
   (make
      (let (N 0  M 1)
         (loop
            (inc 'N (if (=0 (& M 1)) (>> 1 M) M))
            (T (> N Max))
            (link N)
            (inc 'M)))))

(de p (N)
   (cache '(NIL) N
      (if (=0 N)
         1
         (let (Sum 0  Sgn 0)
            (for G (gpentagonals N)
               ((if (< Sgn 2) 'inc 'dec) 'Sum (p (- N G)))
               (setq Sgn (& 3 (inc Sgn))))
            Sum))))
