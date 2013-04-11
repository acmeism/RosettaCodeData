/*REXX program sums the first   N   terms of    1/(i**2),    i=1 ──►  N.*/
parse arg N D .                        /*optional num of terms,  digits.*/
if N=='' | N==','  then N=1000         /*Not specified?  Use the default*/
if D==''           then D=60           /* "      "        "   "     "   */
@sig = 'The significant sum of'        /*literal used in  SAY statement.*/
numeric digits D                       /*use  D  digits  (9 is default).*/
w = length(N)                          /*use max  width for nice output.*/
sum = 0                                /*initialize the  SUM  to zero.  */
old = 1                                /*the SUM to compared to the NEW.*/
p = 0                                  /*significant precision so far.  */
      do j=1  for N                    /*compute for   n   terms.       */
      sum = sum   +   1 / j**2         /*add another term to the sum.   */
      c = compare(sum,old)             /*see how we're doing with prec. */
      if c>p  then do                  /*Got another significant digit? */
                   say  @sig   right(j,w)    "terms is:"    left(sum,c)
                   p = c               /*the new significant precision. */
                   end
      old = sum                        /*use "old" sum for next compare.*/
      end   /*j*/
say
say  'The sum of'   right(N,w)   "terms is:"   /*display sum's preamble.*/
say  sum                               /*display the sum on its own line*/
                                       /*stick a fork in it, we're done.*/
