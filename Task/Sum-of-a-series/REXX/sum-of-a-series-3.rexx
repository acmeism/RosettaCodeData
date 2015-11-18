/*REXX program sums the first   N   terms of    1/(k**2),    k=1 ──►  N.      */
parse arg N D .                        /*obtain optional arguments from C.L.  */
if N=='' | N==','  then N=1000         /*Not specified?  Then use the default.*/
if D=='' | D==','  then D=  60         /* "      "         "   "   "     "    */
numeric digits D                       /*use  D  digits  (nine is the default)*/
w=length(N)                            /*max width for the formatted output.  */
$=0                                    /*initialize the sum to zero.          */
old=1                                  /*the new sum to compared to the old.  */
p=0                                    /*significant decimal precision so far.*/
     do k=1  for N                     /* [↓]  compute for   N   terms.       */
     $=$  +  1/k**2                    /*add a squared reciprocal to the sum. */
     c=compare($,old)                  /*see how we're doing with precision.  */
     if c>p  then do                   /*Got another significant decimal dig? */
                  say 'The significant sum of'  right(k,w) "terms is:" left($,c)
                  p=c                  /*use the new significant precision.   */
                  end                  /* [↑]  display significant part of sum*/
     old=$                             /*use "old" sum for the next compare.  */
     end   /*k*/
say                                              /*display blank line for sep.*/
say 'The sum of'   right(N,w)    "terms is:"     /*display the sum's preamble.*/
say $                                  /*display the sum on its own line.     */
                                       /*stick a fork in it,  we're all done. */
