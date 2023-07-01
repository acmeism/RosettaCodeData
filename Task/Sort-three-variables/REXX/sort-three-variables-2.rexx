/*REXX program sorts  three (numeric)  variables  (X, Y, and  Z)  into ascending order. */
numeric digits 1000                              /*handle some pretty gihugic integers. */      /*can be bigger.*/
parse arg x y z .                                /*obtain the three variables from C.L. */
if x=='' | x==","  then x= 77444                 /*Not specified?  Then use the default.*/
if y=='' | y==","  then y=   -12                 /* "      "         "   "   "     "    */
if z=='' | z==","  then z=     0                 /* "      "         "   "   "     "    */
w= max( length(x), length(y), length(z) )   + 5  /*find max width of the values, plus 5.*/
say '───── original values of X, Y, and Z: '       right(x, w)   right(y, w)   right(z, w)
low = x                                          /*assign a temporary variable.         */
mid = y                                          /*   "   "     "        "              */
high= z                                          /*   "   "     "        "              */
              x= min(low,  mid,  high)           /*determine the lowest value of X,Y,Z. */      /* ◄─── sorting.*/
              z= max(low,  mid,  high)           /*    "      "  highest  "    " " " "  */      /* ◄─── sorting.*/
              y=     low + mid + high - x - z    /*    "      "  middle   "    " " " "  */      /* ◄─── sorting.*/
                                                 /*stick a fork in it,  we're all done. */
say '═════  sorted  values of X, Y, and Z: '    right(x, w)    right(y, w)    right(z, w)
