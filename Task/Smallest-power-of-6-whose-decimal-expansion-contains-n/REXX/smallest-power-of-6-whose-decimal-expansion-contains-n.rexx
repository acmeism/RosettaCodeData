/*REXX pgm finds the smallest (decimal) power of  6  which contains  N,  where  N < 22. */
numeric digits 100                               /*ensure enough decimal digs for  6**N */
parse arg hi .                                   /*obtain optional argument from the CL.*/
if hi=='' | hi==","  then hi= 22                 /*Not specified?  Then use the default.*/
w= 50                                            /*width of a number in any column.     */
               @smp6= ' smallest power of  six  (expressed in decimal)  which contains  N'
say '  N  │ power │'center(@smp6, 20 + w     )   /*display the   title   of the output. */
say '─────┼───────┼'center(""   , 20 + w, '─')   /*   "     "  separator  "  "     "    */

      do j=0  for hi                             /*look for a power of 6 that contains N*/
                     do p=0;   x= 6**p           /*compute a power of six (in decimal). */
                     if pos(j, x)>0  then leave  /*does the power contain an   N ?      */
                     end   /*p*/
      c= commas(x)                               /*maybe add commas to the powe of six. */
      z= right(c, max(w, length(c) ) )           /*show a power of six, allow biger #s. */
      say center(j, 5)'│'center(p, 7)"│"   z     /*display what we have so far  (cols). */
      end   /*j*/

say '─────┴───────┴'center(""   , 20 + w, '─')   /*   "     "  separator  "  "     "    */
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
