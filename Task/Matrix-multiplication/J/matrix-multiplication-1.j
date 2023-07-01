   mp  =:  +/ .*      NB.  Matrix product

   A  =:  ^/~>:i. 4   NB.  Same  A  as in other examples (1 1 1 1, 2 4 8 16, 3 9 27 81,:4 16 64 256)
   B  =:  %.A         NB.  Matrix inverse of A

   '6.2' 8!:2 A mp B
1.00  0.00  0.00  0.00
0.00  1.00  0.00  0.00
0.00  0.00  1.00  0.00
0.00  0.00  0.00  1.00
