/*REXX program multiplies two integers by the  Ethiopian  (or Russian peasant)  method. */
numeric digits 3000                              /*handle some gihugeic integers.       */
parse arg a b .                                  /*get two numbers from the command line*/
say  'a=' a                                      /*display a formatted value of  A.     */
say  'b='   b                                    /*   "    "     "       "    "  B.     */
say  'product='    eMult(a, b)                   /*invoke eMult & multiple two integers.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
eMult:   procedure;  parse arg x,y;  s=sign(x)   /*obtain the two arguments; sign for X.*/
         $=0                                     /*product of the two integers (so far).*/
                      do  while x\==0            /*keep processing while   X   not zero.*/
                      if \isEven(x)  then $=$+y  /*if odd,  then add   Y   to product.  */
                      x= halve(x)                /*invoke the  HALVE   function.        */
                      y=double(y)                /*   "    "   DOUBLE      "            */
                      end   /*while*/            /* [↑]  Ethiopian multiplication method*/
         return $*s/1                            /*maintain the correct sign for product*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
double:  return  arg(1)  * 2                     /*   *   is REXX's  multiplication.    */
halve:   return  arg(1)  % 2                     /*   %    "   "     integer division.  */
isEven:  return  arg(1) // 2 == 0                /*   //   "   "     division remainder.*/
