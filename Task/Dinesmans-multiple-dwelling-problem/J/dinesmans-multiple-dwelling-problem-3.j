P=: (!A.&i.])5                         NB. permutation matrix
'`B C F M S'=: ,{{y&{"1`''}}&>i.5      NB. e.g., B is 0&{"1
Cs=: (B~:4:)`(C~:0:)`(F~:4:)`(F~:0:)`(M>C)`(1<S|@:-F)`(1<F|@:-C)  NB. gerund constraints
'BCFMS' /: {. P [F..{{(x`:6#])y}} Cs   NB. fold, filtering as we go
