/*REXX program sums the first   N   terms of    1/(k**2),    k=1 ──►  N.      */
parse arg N D .                        /*obtain optional arguments from C.L.  */
if N=='' | N==','  then N=1000         /*Not specified?  Then use the default.*/
if D=='' | D==','  then D=  60         /* "      "         "   "   "     "    */
numeric digits D                       /*use  D  digits  (nine is the default)*/
$=0                                    /*initialize the sum to zero.          */
          do k=1  for N                /* [↓]  compute for   N   terms.       */
          $=$  +  1/k**2               /*add a squared reciprocal to the sum. */
          end   /*k*/

say 'The sum of'   N   "terms is:"  $  /*stick a fork in it,  we're all done. */
