/*REXX program computes the mean of the proportion of "0" digits a series of factorials.*/
parse arg $                                      /*obtain optional arguments from the CL*/
if $='' | $=","  then $= 100 1000 10000          /*not specified?  Then use the default.*/
#= words($)                                      /*the number of ranges to be used here.*/
numeric digits 100                               /*increase dec. digs, but only to 100. */
big= word($, #);  != 1                           /*obtain the largest number in ranges. */
                                do i=1  for big  /*calculate biggest  !  using 100 digs.*/
                                != ! * i         /*calculate the factorial of  BIG.     */
                                end   /*i*/
if pos('E', !)>0  then do                        /*In exponential format?  Then get EXP.*/
                       parse var !  'E'  x       /*parse the exponent from the number.  */
                       numeric digits    x+1     /*set the decimal digits to  X  plus 1.*/
                       end                       /* [↑]  the  +1  is for the dec. point.*/

title= ' mean proportion of zeros in the (decimal) factorial products for  N'
say '     N     │'center(title, 80)              /*display the title for the output.    */
say '───────────┼'center(""   , 80, '─')         /*   "     a   sep   "   "     "       */

  do j=1  for #;  n= word($, j)                  /*calculate some factorial ranges.     */
  say center( commas(n), 11)'│' left(0dist(n), 75)...    /*show results for above range.*/
  end   /*j*/

say '───────────┴'center(""   , 80, '─')         /*display a foot sep for the output.   */
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
/*──────────────────────────────────────────────────────────────────────────────────────*/
0dist:  procedure; parse arg z;        != 1;         y= 0
                     do k=1  for z;    != ! * k;     y= y   +   countstr(0, !) / length(!)
                     end   /*k*/
        return y/z
