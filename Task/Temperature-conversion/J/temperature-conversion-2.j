   NB.  Format matrix for printing
   fmt    =:  '0.2' 8!:0 k2KCFR

   NB.  Tag each temp with scale, for human
   NB.  legibility.
   kcfr   =:  0 _1 |: 'KCFR' ,"0 1"_1 >@:fmt

   kcfr 21
K  21.00
C-252.00
F-421.87
R  37.80

   kcfr 0 NB. Absolute zero
K   0.00
C-273.00
F-459.67
R   0.00

   kcfr 21 100 300  NB. List of temps works fine
K  21.00
C-252.00
F-421.87
R  37.80

K 100.00
C-173.00
F-279.67
R 180.00

K 300.00
C  27.00
F  80.33
R 540.00
