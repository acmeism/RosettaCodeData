/*REXX program calculates and displays the  modular inverse  of an integer  X  modulo Y.*/
parse arg x y .                                  /*obtain two integers from the C.L.    */
if x=='' | x==","  then x=   42                  /*Not specified?  Then use the default.*/
if y=='' | y==","  then y= 2017                  /* "      "         "   "   "     "    */
say  'modular inverse of '      x       " by "       y        ' ───► '         modInv(x,y)
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
modInv: parse arg a,b 1 ob;     z= 0             /*B & OB are obtained from the 2nd arg.*/
        $= 1                                     /*initialize modular inverse to unity. */
        if b\=1  then do  while a>1
                      parse value   a/b  a//b  b  z       with      q  b  a  t
                      z= $  -  q * z
                      $= trunc(t)
                      end   /*while*/

        if $<0  then $= $ + ob                   /*Negative?  Then add the original  B. */
        return $
