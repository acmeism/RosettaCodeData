(letfn [(fsin [] (lazy-seq (integrate (fcos))))
        (fcos [] (ps- [1] (integrate (fsin))))]
  (def sinx (fsin))
  (def cosx (fcos)))

(println (take 10 sinx))
; (0 1 0 -1/6 0 1/120 0 -1/5040 0 1/362880)
