/*REXX program sums the first   N   terms of    1/(i**2),    i=1 ──►  N.*/
parse arg N D .                        /*maybe get num of terms, digits.*/
if N=='' | N==','  then N=1000         /*Not specified?  Use the default*/
if D==''           then D=60           /* "      "        "   "     "   */
numeric digits D                       /*use D digits: 9 is default for */
                                       /*REXX, 60 is this pgm's default.*/
w = length(N)                          /*use max  width for nice output.*/
sum=0                                  /*initialize the sum to zero.    */
      do j=1  for N                    /*compute for   N   terms.       */
      sum = sum   +   1 / j**2         /*add another term to the sum.   */
      if   left(j,1)\==1  then iterate /*does J start with a one ?      */
      if  right(j,1)\==0  then iterate /*  "  "  end   "   " zero ?     */
      if substr(j,2)\= 0  then iterate /*  "  "   "    "   all zeroes ? */
      say  'The sum of'   right(j,w)   "terms is:"   sum   /*display it.*/
      end   /*j*/
                                       /*stick a fork in it, we're done.*/
