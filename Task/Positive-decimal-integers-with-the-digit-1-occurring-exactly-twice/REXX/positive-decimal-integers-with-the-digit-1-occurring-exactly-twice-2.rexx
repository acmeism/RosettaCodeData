/*REXX program finds  positive decimal integers  which contain exactly two  ones  (1s). */
parse arg hi cols .                              /*obtain optional argument from the CL.*/
if   hi=='' |   hi==","  then   hi= 1000         /*Not specified?  Then use the default.*/
if cols=='' | cols==","  then cols=   10         /* "      "         "   "   "     "    */
w= 10                                            /*width of a number in any column.     */
title= ' positive decimal integers which contain exactly two ones (1s)  which are  <'  hi
say ' index │'center(title,  1 + cols*(w+1)     )
say '───────┼'center(""   ,  1 + cols*(w+1), '─')
found= 0;                    idx= 1              /*initialize # integers and the index. */
$=                                               /*a list of integers found  (so far).  */
     do j=1  for  hi-1                           /*find positive integers within range. */
     if countstr(1, j)\==2  then iterate         /*Doesn't have exactly 2 one's?  Skip. */       /* ◄■■■■■■■ a filter.*/
     found= found + 1                            /*bump the number of integers found.   */
     $= $ right(j, w)                            /*add an integer to the ──►  $  list.  */
     if found//cols\==0     then iterate         /*have we populated a line of output?  */
     say center(idx, 7)'│'  substr($, 2);   $=   /*display what we have so far  (cols). */
     idx= idx + cols                             /*bump the  index  count for the output*/
     end   /*j*/
                                                 /*stick a fork in it,  we're all done. */
if $\==''  then say center(idx, 7)"│"  substr($, 2)  /*possible display residual output.*/
say '───────┴'center(""   ,  1 + cols*(w+1), '─')
say
say 'Found '       found      title
