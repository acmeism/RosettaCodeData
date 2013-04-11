   mean=: +/ % #
   dev=: - mean
   stddevP=: [: %:@mean *:@dev          NB. A) 3 equivalent defs for stddevP
   stddevP=: [: mean&.:*: dev           NB. B) uses Under (&.:) to apply inverse of *: after mean
   stddevP=: %:@(mean@:*: - *:@mean)    NB. C) sqrt of ((mean of squares) - (square of mean))


   stddevP\ 2 4 4 4 5 5 7 9
0 1 0.942809 0.866025 0.979796 1 1.39971 2
