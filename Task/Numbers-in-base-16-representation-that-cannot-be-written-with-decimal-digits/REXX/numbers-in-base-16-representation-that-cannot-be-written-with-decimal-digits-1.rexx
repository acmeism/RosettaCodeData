/*REXX pgm finds positive integers when shown in hex that can't be written with dec digs*/
parse arg n cols .                               /*obtain optional argument from the CL.*/
if    n=='' |    n==","  then   n = 500          /*Not specified?  Then use the default.*/
if cols=='' | cols==","  then cols=  10          /* "      "         "   "   "     "    */
w= 10                                            /*width of a number in any column.     */
title= " positive integers when shown in hexadecimal that can't be written with"  ,
       'decimal digits,  where  N  < '    n
say ' index │'center(title, 1 + cols*(w+1)     ) /*display the title for the output.    */
say '───────┼'center(""   , 1 + cols*(w+1), '─') /*   "     a   sep   "   "     "       */
found= 0;       y= 0123456789;         idx= 1    /*# finds;  forbidden glyphs;  set IDX.*/
$=                                               /*list of numbers found  (so far).     */
    do j=1  for n-1                              /*find ints in hex with no dec. digits.*/
    if verify(y, d2x(j), 'M')\==0  then iterate  /*Any dec. digs in hex number?   Skip. */    /* ◄■■■■■■■■ the filter. */
    found= found + 1                             /*bump number of found such numbers.   */
    $= $  right(j, w)                            /*add the found number  ───►  $  list. */
    if found // cols \== 0        then iterate   /*have we populated a line of output?  */
    say center(idx, 7)'│'  substr($, 2);   $=    /*display what we have so far  (cols). */
    idx= idx + cols                              /*bump the  index  count for the output*/
    end   /*j*/

if $\==''  then say center(idx, 7)"│"  substr($, 2)  /*possible display residual output.*/
say '───────┴'center(""   , 1 + cols*(w+1), '─')     /*display the foot sep for output. */
say
say 'Found '          found          title
exit 0                                           /*stick a fork in it,  we're all done. */
