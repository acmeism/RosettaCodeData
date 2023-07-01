   index=: $ #: I.@:,
   factorion=: 10&$: :(] = [: +/ [: ! #.^:_1)&>

   FACTORIONS=: 9 0 +"1 index Q=: 9 10 11 12 factorion/ i. 1500000

   NB. columns: base, factorion in base 10, factorion in base
   (,. ".@:((Num_j_,26}.Alpha_j_) {~ #.inv/)"1) FACTORIONS
 9     1     1
 9     2     2
 9 41282 62558
10     1     1
10     2     2
10   145   145
10 40585 40585
11     1     1
11     2     2
11    26    24
11    48    44
11 40472 28453
12     1     1
12     2     2

   NB. tallies of factorions in the bases
   (9+i.4),.+/"1 Q
 9 3
10 4
11 5
12 2
