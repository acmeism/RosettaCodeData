/*REXX program sorts three (any value)  variables  (X, Y, and  Z)  into ascending order.*/
parse arg x y z .                                /*obtain the three variables from C.L. */
if x=='' | x==","  then x= 'lions, tigers, and'        /*Not specified?  Use the default*/
if y=='' | y==","  then y= 'bears,  oh my!'            /* "      "        "   "     "   */
if z=='' | z==","  then z= '(from "The Wizard of Oz")' /* "      "        "   "     "   */
say '───── original value of X: '   x
say '───── original value of Y: '   y
say '───── original value of Z: '   z
if x>y  then do;   _= x;   x= y;   y= _;   end   /*swap the values of   X   and   Y.    */      /* ◄─── sorting.*/
if y>z  then do;   _= y;   y= z;   z= _;   end   /*  "   "     "    "   Y    "    Z.    */      /* ◄─── sorting.*/
if x>y  then do;   _= x;   x= y;   y= _;   end   /*  "   "     "    "   X    "    Y.    */      /* ◄─── sorting */
say                                              /*stick a fork in it,  we're all done. */
say '═════  sorted  value of X: '   x
say '═════  sorted  value of Y: '   y
say '═════  sorted  value of Z: '   z
