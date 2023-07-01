/*REXX program finds the largest (decimal) integer divisible by all its decimal digits. */
$= 7 * 8 * 9                                     /*a # that it must divide the found #. */
t= 0                                             /*the number of divisibility trials.   */
     do #=9876432 % $ * $        by -$           /*search from largest number downwards.*/
     if # // $             \==0  then iterate    /*Not divisible?   Then keep searching.*/
     if verify(50, #, 'M') \==0  then iterate    /*does it contain a  five  or a  zero? */
     t= t+1                                      /*curiosity's sake, track # of trials. */
            do j=1  for length(#) - 1            /*look for a possible duplicated digit.*/
            if pos( substr( #, j, 1), #, j+1) \==0  then iterate #
            end   /*j*/                          /* [↑]  Not unique? Then keep searching*/
                                                 /* [↓]  superfluous, but check anyways.*/
            do v=1  for length(#)                /*verify the # is divisible by all digs*/
            if # // substr(#, v, 1)           \==0  then iterate #
            end   /*v*/                          /* [↑]  ¬divisible?  Then keep looking.*/
     leave                                       /*we found a number, so go display it. */
     end         /*#*/

say 'found '   #    "  (in "   t   ' trials)'    /*stick a fork in it,  we're all done. */
