/*REXX program determines what characters are  lowercase and uppercase  (Latin) letters.*/
$L=                                              /*set lowercase alphabet string to null*/
$U=                                              /* "  uppercase     "       "    "   " */
    do #=0  for 2**8                             /*traipse through  all  the characters.*/
                                    _=d2c(#)     /*convert decimal number to character. */
    if datatype(_, 'L')  then $L=$L _            /*Lowercase?  Then add char to the list*/
    if datatype(_, 'U')  then $U=$U _            /*Uppercase?    "   "   "    "  "    " */
    end   /*#*/                                  /* [↑]  put all the letters into a list*/

say '    lowercase letters: '   $L               /*display all the  lowercase  letters. */
say '    uppercase letters: '   $U               /*   "     "   "   uppercase     "     */
                                                 /*stick a fork in it,  we're all done. */
