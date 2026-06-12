/*REXX program appends a  "3"  to a number of  "1"s,  and  then squares that number.    */
numeric digits 1000                              /*be able to handle huge numbers.      */
parse arg n .                                    /*obtain optional argument from the CL.*/
if n=='' | n==","  then n= 9                     /*Not specified?  Then use the default.*/
_= copies(1, n)3                                 /*compute largest index to get width.  */
w1= length( commas(_)    )                       /*get the width of the largest index.  */
w2= length( commas(_**2) )                       /* "   "    "    "  "     "    number. */

       do #=0  to n;  _=copies(1, #)3            /*calculate prefix number for output.  */
       say right( commas(_), w1)  right( commas(_**2), w2)       /*show prefix, number. */
       end   /*#*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
