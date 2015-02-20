/*REXX pgm creates an indexable string of lowercase ASCII characters  a ──► z */
LC=''                                     /*set lowercase letters list to null*/
       do j=0  for 2**8;   _=d2c(j)       /*convert decimal  J  to character. */
       if datatype(_,'L')  then LC=LC||_  /*Lowercase?  Then add it to LC list*/
       end   /*j*/                        /* [↑]  add lowercase letters ──► LC*/
say LC                                    /*stick a fork in it, we're all done*/
