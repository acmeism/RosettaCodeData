   X=: x ^/ i.3                  NB. form Design matrix
   X=: (x^0) ,. (x^1) ,. (x^2)   NB. equivalent of previous line
   4{.X                          NB. show first 4 rows of X
1 1.47 2.1609
1  1.5   2.25
1 1.52 2.3104
1 1.55 2.4025

   NB. Where y is a set of observations and X is the design matrix
   NB. y %. X does matrix division and gives the regression coefficients
   y %. X
128.813 _143.162 61.9603
