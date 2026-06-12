/*REXX program  finds and displays  (positive integers)  squares  that begin with  N.   */
numeric digits 20                                /*ensure that large numbers can be used*/
parse arg n cols .                               /*get optional number of primes to find*/
if    n=='' |    n==","  then    n= 50           /*Not specified?   Then assume default.*/
if cols=='' | cols==","  then cols= 10           /* "      "          "     "       "   */
w= 10                                            /*width of a number in any column.     */
say ' index │'center(" smallest squares that begin with  N  < "   n,  1 + cols*(w+1)     )
say '───────┼'center(""                                            ,  1 + cols*(w+1), '─')
#= 0;                  idx= 1                    /*initialize count of found #'s and idx*/
$=;                    nn= n - 1                 /*a list of additive primes  (so far). */
       do j=1  while #<nn                        /*keep searching 'til enough nums found*/
                 do k=1  until pos(j, k * k)==1  /*compute a square of some number.     */
                 end   /*k*/
       #= # + 1                                  /*bump the count of numbers found.     */
                  c= commas(k * k)               /*calculate  K**2 (with commas)  and L */
       $= $ right(c, max(w, length(c) ) )        /*add square to $ list, allow for big N*/
       if #//cols\==0  then iterate              /*have we populated a line of output?  */
       say center(idx, 7)'│'  substr($, 2);  $=  /*display what we have so far  (cols). */
       idx= idx + cols                           /*bump the  index  count for the output*/
       end   /*j*/

if $\==''  then say center(idx, 7)"│"  substr($, 2)  /*possible display residual output.*/
say '───────┴'center(""                                            ,  1 + cols*(w+1), '─')
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
