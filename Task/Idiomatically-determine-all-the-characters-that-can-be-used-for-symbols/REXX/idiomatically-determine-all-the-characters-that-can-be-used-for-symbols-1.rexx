/*REXX program determines what  characters  are valid for REXX symbols. */
@=                                     /*set   symbol characters "   "  */
   do j=0  for 2**8                    /*traipse through all the chars. */
   _=d2c(j)                            /*convert decimal number to char.*/
   if datatype(_,'S')  then @=@ || _   /*Symbol char?  Then add to list.*/
   end   /*j*/                         /* [↑] put some chars into a list*/

say '     symbol characters: '  @      /*display all  symbol characters.*/
                                       /*stick a fork in it, we're done.*/
