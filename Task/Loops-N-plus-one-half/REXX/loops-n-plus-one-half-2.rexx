/*REXX program displays:                 1,2,3,4,5,6,7,8,9,10                           */

     do j=1  for 10                              /*using   FOR   is faster than    TO.  */
     call charout ,j || left(',',j<10)           /*display  J, maybe append a comma (,).*/
     end   /*j*/
                                                 /*stick a fork in it,  we're all done. */
