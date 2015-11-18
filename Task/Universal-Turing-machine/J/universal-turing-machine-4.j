   NB. Probable 5-state, 2-symbol busy beaver...
   NB.        0         1      Tape Symbol Scan
   NB. S   p  m  g   p  m  g  (p,m,g) → (print,move,goto)
   QS=. (Noun _) ; 0          NB. Reading the transition table and setting the state
       0   1  1  1   1 _1  2
       1   1  1  2   1  1  1
       2   1  1  3   0 _1  4
       3   1 _1  0   1 _1  3
       4   1  1 _1   0 _1  0
)
   TPF=. 0 ; 0 ; _            NB. Setting the tape, its pointer and the display frequency

   TPF utm QS                 NB. Running the Turing machine...
0 0:0
0 :^
4 0     :101001001001001001001001001001001001001001001001001001001001001001001001001001001001001001001001001001...
47176870: ^
