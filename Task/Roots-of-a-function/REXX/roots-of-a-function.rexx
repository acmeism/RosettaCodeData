/*REXX program finds the roots of a specific function:  x^3 - 3*x^2 + 2*x  via bisection*/
parse arg bot top inc .                          /*obtain optional arguments from the CL*/
if bot=='' | bot==","  then bot= -5              /*Not specified?  Then use the default.*/
if top=='' | top==","  then top= +5              /* "       "        "   "   "     "    */
if inc=='' | inc==","  then inc=   .0001         /* "       "        "   "   "     "    */
z=f(bot-inc);                 !=sign(z)          /*use these values for initial compare.*/

      do j=bot  to top  by  inc                  /*traipse through the specified range. */
      z=f(j);              $=sign(z)             /*compute new value;  obtain the sign. */
      if z=0  then                                 say  'found an exact root at'   j/1
              else if  !\==$  then  if !\==0  then say  'passed a root at'         j/1
      !=$                                        /*use the new sign for the next compare*/
      end   /*j*/                                /*dividing by unity normalizes J  [↑]  */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
f:    parse arg x;     return x*(x*(x-3)+2)      /*formula used   ──► x^3 - 3x^2  + 2x  */
                                                 /*with factoring ──► x{ x^2 -3x  + 2 } */
                                                 /*more     "     ──► x{ x( x-3 ) + 2 } */
