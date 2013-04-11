: (mapcar ffr (range 1 10))
-> (1 3 7 12 18 26 35 45 56 69)

: (=
   (range 1 1000)
   (sort (conc (mapcar ffr (range 1 40)) (mapcar ffs (range 1 960)))) )
-> T
