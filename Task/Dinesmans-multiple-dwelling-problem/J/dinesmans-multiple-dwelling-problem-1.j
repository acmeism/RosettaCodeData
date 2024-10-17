'B C F M S'=:<"1|: P=:(!A.&i.])5   NB. perm matrix and named columns
Cs=: (B~:4),(C~:0),(F~:4),(F~:0),(M>C),(1<|S-F),:(1<|F-C)  NB. constraints
'BCFMS'/:{.P#~*./Cs                NB. join constraints; filter; apply resulting permutation
