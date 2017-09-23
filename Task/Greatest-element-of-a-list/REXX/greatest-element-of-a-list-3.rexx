/*REXX program finds the  greatest element  in a list of numbers entered at the terminal*/
say '──────────────────  Please enter a list of numbers  (separated by blanks or commas):'
parse pull $;           #=words($)               /*get a list of numbers from terminal. */
$=translate($, , ',')                            /*change all commas  (,)  to  blanks.  */
big=word($,1);          do j=2  to #             /*traipse through the list of numbers. */
                        big=max(big, word($,j))  /*use a BIF for finding the max number.*/
                        end   /*j*/
say                                              /*stick a fork in it,  we're all done. */
say '────────────────── The biggest value in the list of '    #    " elements is: "    big
