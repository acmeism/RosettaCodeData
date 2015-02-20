   NB. Format matrix for printing & tag each
   NB. temp with scale, for human legibility
   fmt    =:  [: (;:inv"1) 0 _1 |: 'KCFR' ;"0 1"_1 '0.2' 8!:0 ]
   kcfr   =:  fmt@k2KCFR

   kcfr 21
K   21.00
C -252.00
F -421.87
R   37.80

   kcfr 0 NB. Absolute zero
K    0.00
C -273.00
F -459.67
R    0.00

   kcfr 21 100 300  NB. List of temps works fine
K   21.00  100.00  300.00
C -252.00 -173.00   27.00
F -421.87 -279.67   80.33
R   37.80  180.00  540.00
