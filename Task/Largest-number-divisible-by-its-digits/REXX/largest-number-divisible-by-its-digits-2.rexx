/*REXX program finds the largest  hexadecimal  integer divisible by all its hex digits. */
numeric digits 20                                /*be able to handle the large hex nums.*/
bigH= 'fedcba987654321'                          /*biggest number possible, hexadecimal.*/
bigN= x2d(bigH)                                  /*   "       "       "     decimal.    */
$= 15 * 14 * 13 * 12 * 11                        /*a # that it must divide the found #. */
t= 0                                             /*the number of divisibility trials.   */
     do #=bigN % $ * $       by -$               /*search from largest poss. # downwards*/
     if # // $    \==0  then iterate             /*Not divisible?   Then keep searching.*/
     h= d2x(#)                                   /*convert decimal number to hexadecimal*/
     if pos(0, h) \==0  then iterate             /*does hexadecimal number contain a 0? */
     t= t+1                                      /*curiosity's sake, track # of trials. */
            do j=1  for length(h) - 1            /*look for a possible duplicated digit.*/
            if pos( substr(h, j, 1),  h, j+1) \==0  then iterate #
            end   /*j*/                          /* [↑]  Not unique? Then keep searching*/

            do v=1  for length(h)                /*verify the # is divisible by all digs*/
            if # // x2d(substr( h, v, 1)  )   \==0  then iterate #
            end   /*v*/                          /* [↑]  ¬divisible?  Then keep looking.*/
     leave                                       /*we found a number, so go display it. */
     end          /*#*/

say 'found '    h    "  (in "    t    ' trials)' /*stick a fork in it,  we're all done. */
