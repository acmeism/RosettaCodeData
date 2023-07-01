   genrange 9 2 _2   NB. valid
9 7 5 3
   genrange _2 2 1   NB. valid
_2 _1 0 1 2
   genrange _2 2 0   NB. invalid: requires at least an infinity of values
|domain error: genrange
   genrange _2 2 _1   NB. projects backwards from _2
_4 _3 _2
   genrange _2 2 10   NB. valid
_2
   genrange 2 _2 1   NB. projects backwards from 2
4 3 2
   genrange 2 2 1   NB. valid (increment is irrelevant)
2
   genrange 2 2 _1   NB. valid (increment is irrelevant)
2
   genrange 2 2 0   NB. valid (increment is irrelevant)
2
   genrange 0 0 0   NB. valid (increment is irrelevant)
0
