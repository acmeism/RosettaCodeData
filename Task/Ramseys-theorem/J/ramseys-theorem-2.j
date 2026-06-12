   comb=: 4 : 0 M.   NB. All size x combinations of i.y
     if. (x>:y)+.0=x do. i.(x<:y),x else. (0,.x comb&.<: y),1+x comb y-1 end.
   )

   NB. returns 1 iff the subbmatrix of y consisting of the columns and rows labelled x contains both 1 and 0
   checkRow =. 4 : 0 "1 _
     *./ 0 1 e. ,x{"1 x{y
   )

   *./ (4 comb 17) checkRow ramsey 17
1
