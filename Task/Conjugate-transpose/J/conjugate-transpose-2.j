   X         =: +/ . *             NB. Matrix Multiply (x)

   HERMITIAN =:  3 2j1 ,: 2j_1 1
   (-: ct) HERMITIAN               NB.  A_ct = A
1

   NORMAL    =:  1 1 0 , 0 1 1 ,: 1 0 1
   ((X~ -: X) ct) NORMAL           NB. A_ct x A = A x A_ct
1

   UNITARY   =:  (-:%:2) * 1 1 0 , 0j_1 0j1 0 ,: 0 0 0j1 * %:2
   (ct -: %.)  UNITARY             NB.  A_ct = A^-1
1
