/*REXX program finds the  lowest (positive)  integer  whose  square  ends in  269,696.  */
   do j=2  by 2  until right(j * j, 6) == 269696 /*start  J  at two,  increment by two. */
   end                                           /*◄── signifies the end of the DO loop.*/
                                                 /* [↑]     *     means multiplication. */
say "The smallest integer whose square ends in  269,696  is: "    j
