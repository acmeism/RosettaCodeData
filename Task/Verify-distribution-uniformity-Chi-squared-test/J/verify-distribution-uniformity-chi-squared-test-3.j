   FairDistrib=:      1e6 ?@$ 5
   UnfairDistrib=: (9.5e5 ?@$ 5) , (5e4 ?@$ 4)
   isUniformX FairDistrib
1
   isUniformX UnfairDistrib
0
   isUniform 4 4 4 5 5 5 5 5 5 5     NB. uniform if only 2 categories possible
1
   4 isUniform 4 4 4 5 5 5 5 5 5 5   NB. not uniform if 4 categories possible
0
