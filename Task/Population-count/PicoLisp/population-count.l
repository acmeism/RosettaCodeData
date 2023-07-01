(de popz (N)
   (cnt
      '((N) (= "1" N))
      (chop (bin N)) ) )

(println
   'pops:
   (mapcar
      '((N) (popz (** 3 N)))
      (range 0 29) ) )
(setq N -1)
(println
   'evil:
   (make
      (for (C 0 (> 30 C))
         (unless (bit? 1 (popz (inc 'N)))
            (link N)
            (inc 'C) ) ) ) )
(setq N -1)
(println
   'odio:
   (make
      (for (C 0 (> 30 C))
         (when (bit? 1 (popz (inc 'N)))
            (link N)
            (inc 'C) ) ) ) )
