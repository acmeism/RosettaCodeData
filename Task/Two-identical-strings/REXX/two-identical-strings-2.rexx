/*REXX program finds/displays decimal numbers whose binary version is a doubled literal.*/
numeric digits 100                               /*ensure hangling of larger integers.  */
parse arg hi cols .                              /*obtain optional argument from the CL.*/
if   hi=='' |   hi==","  then   hi= 1000         /* "      "         "   "   "     "    */
if cols=='' | cols==","  then cols=    4         /* "      "         "   "   "     "    */
w= 20                                            /*width of a number in any column.     */
title= ' decimal integers whose binary version is a doubled binary literal, N  < '   ,
                                                                       commas(hi)
if cols>0  then say ' index │'center(title,   1 + cols*(w+1)     )
if cols>0  then say '───────┼'center(""   ,   1 + cols*(w+1), '─')
#= 0;                   idx= 1                   /*initialize # of integers and index.  */
$=                                               /*a list of  nice  primes  (so far).   */
     do j=1  for hi-1;  b= x2b( d2x(j) ) + 0     /*find binary values that can be split.*/
     L= length(b);      h= L % 2                 /*obtain length of the binary value.   */
     if L//2                      then iterate   /*Can binary version be split? No, skip*/
     if left(b, h)\==right(b, h)  then iterate   /*Left half match right half?   "    " */
     #= # + 1                                    /*bump the number of integers found.   */
     if cols<=0                   then iterate   /*Build the list  (to be shown later)? */
     c= commas(j) || '(' || b")"                 /*maybe add commas, add binary version.*/
     $= $  right(c, max(w, length(c) ) )         /*add a nice prime ──► list, allow big#*/
     if #//cols\==0               then iterate   /*have we populated a line of output?  */
     say center(idx, 7)'│'  substr($, 2);   $=   /*display what we have so far  (cols). */
     idx= idx + cols                             /*bump the  index  count for the output*/
     end   /*j*/

if $\==''  then say center(idx, 7)"│"  substr($, 2)  /*possible display residual output.*/
if cols>0  then say '───────┴'center(""   ,   1 + cols*(w+1), '─')
say
say 'Found '       commas(#)         title
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
