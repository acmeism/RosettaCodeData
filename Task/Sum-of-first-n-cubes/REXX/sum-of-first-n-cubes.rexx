/*REXX program finds and displays a number of sums of the first  N  cubes, where N < 50 */
parse arg n cols .                               /*obtain optional argument from the CL.*/
if    n=='' |    n==","  then    n=   50         /*Not specified?  Then use the default.*/
if cols=='' | cols==","  then cols=   10         /* "      "         "   "   "     "    */
w= 12                                            /*width of a number in any column.     */
                     title= ' cube sums,  where  N  < '     commas(n)
say ' index │'center(title,  1 + cols*(w+1)     )
say '───────┼'center(""   ,  1 + cols*(w+1), '─')
found= 0;                  idx= 0                /*initialize the number for the index. */
$=;                        sum= 0                /*a list of the sum of  N  cubes.  .   */
     do j=0  for n;        sum= sum + j**3       /*compute the sum of this cube + others*/
     found= found + 1                            /*bump the number of  sums  shown.     */
     c= commas(sum)                              /*maybe add commas to the number.      */
     $= $ right(c, max(w, length(c) ) )          /*add a sum of  N  cubes to the $ list.*/
     if found//cols\==0  then iterate            /*have we populated a line of output?  */
     say center(idx, 7)'│'  substr($, 2);   $=   /*display what we have so far  (cols). */
     idx= idx + cols                             /*bump the  index  count for the output*/
     end   /*j*/

if $\==''  then say center(idx, 7)"│"  substr($, 2)  /*possible display residual output.*/
say '───────┴'center(""   ,  1 + cols*(w+1), '─')
say
say 'Found '       commas(found)       title
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
