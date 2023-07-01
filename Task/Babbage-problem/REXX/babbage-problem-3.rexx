/*REXX program finds the  lowest (positive)  integer  whose  square  ends in  269,696.  */
/*─────────────────── we will only examine integers that are ending  in  four  or  six. */
   do j=4  by 10                                 /*start  J  at four,  increment by ten.*/
   k = j                                         /*set    K  to  J's  value.            */
   if right(k * k, 6) == 269696  then leave      /*examine right-most 6 decimal digits. */
                                                 /*      ==  means exactly equal to.    */
   k = j+2                                       /*set    K  to  J+2  value.            */
   if right(k * k, 6) == 269696  then leave      /*examine right-most 6 decimal digits. */
   end                                           /*◄── signifies the end of the DO loop.*/
                                                 /* [↑]      *    means multiplication. */
say "The smallest integer whose square ends in  269,696  is: "   k
