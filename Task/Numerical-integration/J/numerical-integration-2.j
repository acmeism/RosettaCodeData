   Ir=: rectangle integrate
   It=: trapezium integrate
   Is=: simpson integrate

   ^&3 Ir 0 1 100
0.249987
   ^&3 It 0 1 100
0.250025
   ^&3 Is 0 1 100
0.25
   % Ir 1 100 1000
4.60476
   % It 1 100 1000
4.60599
   % Is 1 100 1000
4.60517
   ] Ir 0 5000 5e6
1.25e7
   ] It 0 5000 5e6
1.25e7
   ] Is 0 5000 5e6
1.25e7
   ] Ir 0 6000 6e6
1.8e7
   ] It 0 6000 6e6
1.8e7
   ] Is 0 6000 6e6
1.8e7
