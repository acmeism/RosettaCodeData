(setq *RNext 2)

(de ffr (N)
   (cache '(NIL) N
      (if (= 1 N)
         1
         (+ (ffr (dec N)) (ffs (dec N))) ) ) )

(de ffs (N)
   (cache '(NIL) N
      (if (= 1 N)
         2
         (let S (inc (ffs (dec N)))
            (when (= S (ffr *RNext))
               (inc 'S)
               (inc '*RNext) )
            S ) ) ) )
