   NB. test arbitrary vector being real (and having the specified result)
   clean gmul~ +/ (e 0 1 2 3 4) gmul 1 _1 2 3 _2 (0 ndx01) vzero
0 │ 19

   NB. required orthogonality
   clean gdot&e&>/~i.4
0 0 0 │ 1
1 1 0 │ 1
2 2 0 │ 1
3 3 0 │ 1

   NB. i j k
   i=: 0 gmul&e 1
   j=: 1 gmul&e 2
   k=: 0 gmul&e 2

   i gmul i
0 │ _1
   j gmul j
0 │ _1
   k gmul k
0 │ _1
   i gmul j gmul k
0 │ _1

   NB. I J K
   I=: 1 gmul&e 2
   J=: 2 gmul&e 3
   K=: 1 gmul&e 3

   I gmul I
0 │ _1
   J gmul J
0 │ _1
   K gmul K
0 │ _1
   I gmul J gmul K
0 │ _1
   K-J
10 │  1
12 │ _1
   I gmul J+K
10 │  1
12 │ _1
