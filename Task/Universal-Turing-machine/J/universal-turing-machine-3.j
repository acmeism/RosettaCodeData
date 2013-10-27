   NB. Three-state busy beaver..
   NB.        0         1     Tape Symbol Scan
   NB. S   p  m  g   p  m  g  (p,m,g) → (print,move,goto)
   QS=. (noun _) ; 0          NB. Reading the transition table and setting the initial state
       0   1  1  1   1 _1  2
       1   1 _1  0   1  1  1
       2   1 _1  1   1  0 _1
)
   TPF=. 0 ; 0 ; 1            NB. Setting the tape, its pointer and the display frequency

   TPF utm QS                 NB. Running the Turing machine...
0 0:0
0  :^
1 0:10
1  : ^
0 1:11
2  :^
2 0:011
3  :^
1 0:0111
4  :^
0 0:01111
5  :^
1 1:11111
6  : ^
1 1:11111
7  :  ^
1 1:11111
8  :   ^
1 1:11111
9  :    ^
1 0:111110
10 :     ^
0 1:111111
11 :    ^
2 1:111111
12 :   ^
2 1:111111
13 :   ^
