/*REXX program finds special divisors:   numbers  N  such that  reverse(D)  divides ··· */
/*────────────────────────── reverse(N)  for all divisors  D  of  N,  where  N  <  200. */
parse arg hi cols .                              /*obtain optional argument from the CL.*/
if   hi=='' |   hi==","  then   hi=  200         /* "      "         "   "   "     "    */
if cols=='' | cols==","  then cols=   10         /* "      "         "   "   "     "    */
w= 10                                            /*width of a number in any column.     */
title= ' special divisors  N  that reverse(D) divides reverse(N) for all divisors'  ,
       ' D  of  N,   where  N  < '    hi
if cols>0  then say ' index │'center(title,     1 + cols*(w+1)     )
if cols>0  then say '───────┼'center(""  ,      1 + cols*(w+1), '─')
found= 0;                   idx= 1               /*initialize # found numbers and index.*/
$=                                               /*a list of numbers found  (so far).   */
     do j=1  for  hi-1;     r= reverse(j)        /*search for special divisors.         */
                    do k=2  to j%2               /*skip the first divisor (unity) & last*/
                    if j//k==0  then if r//reverse(k)\==0  then iterate J /*Not OK? Skip*/
                    end   /*m*/
     found= found+1                              /*bump the number of special divisors. */
     if cols<0              then iterate         /*Build the list  (to be shown later)? */
     $= $ right(j, w)                            /*add a special divisor ──► the $ list.*/
     if found//cols\==0     then iterate         /*have we populated a line of output?  */
     say center(idx, 7)'│'  substr($, 2);    $=  /*display what we have so far  (cols). */
     idx= idx + cols                             /*bump the  index  count for the output*/
     end   /*j*/

if $\==''  then say center(idx, 7)"│"  substr($, 2)  /*possible display residual output.*/
if cols>0  then say '───────┴'center(""  ,      1 + cols*(w+1), '─')
say
say 'Found '      found         title
