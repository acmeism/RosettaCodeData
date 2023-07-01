   A=: 2 3 5 7 11    NB. legal
   B=: 999           NB. legal
   B 0} A            NB. functional array update (does not change A)
   NB. the use of a single brace to denote indexing might also confuse people
999 3 5 7 11
   0} A              NB. legal
2
   999 0} A          NB. not legal
|rank error
   (999)0} A         NB. what was intended
999 3 5 7 11
