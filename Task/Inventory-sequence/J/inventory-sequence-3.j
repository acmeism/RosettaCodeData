   stretch=: }.nextinv^:(10000>{:)^:_]0    NB. or
   stretch=: (1e4<:{:) invseq   NB. equivalent, faster approach

   (,~ {&stretch) {.I.2000<stretch   NB. first value greater than 2000 and its index
2009 43301
   (,~ {&stretch) {.I.3000<stretch
3001 61708
   (,~ {&stretch) {.I.4000<stretch
4003 81456
   (,~ {&stretch) {.I.5000<stretch
5021 98704
   (,~ {&stretch) {.I.6000<stretch
6009 121342
   (,~ {&stretch) {.I.7000<stretch
7035 151756
   (,~ {&stretch) {.I.8000<stretch
8036 168804
   (,~ {&stretch) {.I.9000<stretch
9014 184428
   (,~ {&stretch) {.I.10000<stretch
10007 201788
   require'plot'
   plot 1e4{.stretch
