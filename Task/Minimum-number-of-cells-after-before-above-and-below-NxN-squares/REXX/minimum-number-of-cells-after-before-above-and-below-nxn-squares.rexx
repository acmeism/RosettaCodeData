/*REXX pgm finds the minimum# of cells after, before, above, & below a NxN square matrix*/
parse arg $                                      /*obtain optional arguments from the CL*/
if $='' | $=","  then $= 21 10 9 2 1             /*Not specified?  Then use the default.*/
             @title= ' the minimum number of cells after, before, above, and below a '
  do j=1  for words($);     g= word($, j)        /*process each of the squares specified*/
  w= length( (g-1) % 2)                          /*width of largest number to be shown. */
  say center(@title g"x"g ' square matrix ', 86) /*center title of output to be shown.  */
  say center('',    86, '─')                     /*display a separator line below title.*/

     do     r=0  for g                           /*process output for a  NxN  sq. matrix*/
     _= left('', max(0, 85%(w+1) -g ) )          /*compute indentation output centering.*/
         do c=0  for g
         _= _ right( min(r, c, g-r-1, g-c-1), w) /*construct a row of the output matrix.*/
         end   /*c*/
     say _                                       /*display a row of the output square.  */
     end       /*r*/

   say;  say                                     /*display 2 blank lines between outputs*/
   end         /*j*/                             /*stick a fork in it,  we're all done. */
