/*REXX program creates an indexable string of lowercase ASCII or EBCDIC characters: a─►z*/
$=                                               /*set lowercase letters list to  null. */
      do j=0  for 2**8;                _=d2c(j)  /*convert decimal  J  to a character.  */
      if datatype(_, 'L')  then $=$ || _         /*Is lowercase?  Then add it to $ list.*/
      end   /*j*/                                /* [↑]  add lowercase letters ──► $    */
say $                                            /*stick a fork in it,  we're all done. */
