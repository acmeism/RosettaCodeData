   NB. Simple Incrementer...
   NB.        0         1     Tape Symbol Scan
   NB. S   p  m  g   p  m  g  (p,m,g) → (print,move,goto)
   QS=. (noun _) ; 0          NB. Reading the transition table and setting the initial state
       0   1  0 _1   1  1  0
)
   TPF=. 1 1 1 ; 0 ; 1        NB. Setting the tape, its pointer and the display frequency

   TPF utm QS                 NB. Running the Turing machine...
0 1:111
0  :^
0 1:111
1  : ^
0 1:111
2  :  ^
0 0:1110
3  :   ^
0 0:1111
4  :   ^
