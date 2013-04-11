(prin "SIN:")
(for N (range 1 11 2)
   (prin " " (round (fpsSin N) 9)) )
(prinl)

(prin "COS:")
(for N (range 0 10 2)
   (prin " " (round (fpsCos N) 9)) )
(prinl)

(prin "TAN:")
(for N (range 1 13 2)
   (prin " " (round (fpsTan N) 7)) )
(prinl)

(prin "EXP:")
(for N (range 0 6)
   (prin " " (round (fpsExp N) 7)) )
(prinl)
