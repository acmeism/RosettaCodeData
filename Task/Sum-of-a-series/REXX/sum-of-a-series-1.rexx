/*REXX program sums the first   N   terms of    1/(i**2),    i=1 ──►  N.*/
parse arg N D .                        /*maybe get num of terms, digits.*/
if N=='' | N==','  then N=1000         /*Not specified?  Use the default*/
if D==''           then D=60           /* "      "        "   "     "   */
numeric digits D                       /*use D digits: 9 is default for */
                                       /*REXX, 60 is this pgm's default.*/
w = length(N)                          /*use max  width for nice output.*/
sum = 0                                /*initialize the sum to zero.    */
          do j=1  for N                /*compute for   N   terms.       */
          sum = sum   +   1 / j**2     /*add another term to the sum.   */
          end   /*j*/

say  'The sum of'   right(N,w)   "terms is:"   sum
                                       /*stick a fork in it, we're done.*/
