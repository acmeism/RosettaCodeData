   NB. Sorting stress test...
   NB.        0         1         2         3     Tape Symbol Scan
   NB. S   p  m  g   p  m  g   p  m  g   p  m  g  (p,m,g) ➜ (print,move,goto)
   QS=. (noun _) ; 0          NB. Reading the transition table and setting the initial state
       0   0 _1  4   1  1  0   3  1  1   _  _  _
       1   0 _1  2   1  1  1   2  1  1   _  _  _
       2   _  _  _   2 _1  3   2 _1  2   2 _1  4
       3   _  _  _   1 _1  3   2 _1  3   1  1  0
       4   0  1 _1   1 _1  4   _  _  _   _  _  _
)
   TPF=. 1 2 2 1 2 2 1 2 1 2 1 2 1 2 ; 0 ; 50   NB. Setting the tape, its pointer and the display frequency

   TPF utm QS                 NB. Running the Turing machine...
0 1:12212212121212
0  :^
3 2:113122121222220
50 :    ^
1 2:111111322222220
100:            ^
4 0:0111111222222220
118: ^
