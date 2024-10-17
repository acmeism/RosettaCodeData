   'B C F M S'=:<"1|: P=:(!A.&i.])5  NB. perm matrix and named columns

   NB. parse constraints -> fold -> filter:
   'BCFMS'/:{.P#~*./ ".;._2 (0 :0)
B~:4        NB. Baker not on 5th floor
C~:0        NB. Cooper not on 1st floor
F~:4        NB. Fletcher not on 5th floor...
F~:0        NB. ... nor on 1st floor
M>C         NB. Miller on higher floor than Cooper
1<|S-F      NB. Smith and Fletcher not on adjacent floors
1<|F-C      NB. Fletcher and Cooper not on adjacent floors
)
