/*REXX program finds & displays  N  Sundaram primes, or displays the Nth Sundaram prime.*/
parse arg n cols .                               /*get optional number of primes to find*/
if    n=='' |    n==","  then    n= 100          /*Not specified?   Then assume default.*/
if cols=='' | cols==","  then cols=  10          /* "      "          "     "       "   */
@.= .;                             lim= 16 * n   /*default value for array; filter limit*/
       do    j=1  for n;   do k=1  for n  until _>lim;  _= j + k + 2*j*k;  @._=
                           end   /*k*/
       end      /*j*/
w= 10                                            /*width of a number in any column.     */
                                     title= 'a list of '   commas(N)   " Sundaram primes"
if cols>0  then say ' index │'center(title,  1 + cols*(w+1)     )
if cols>0  then say '───────┼'center(""   ,  1 + cols*(w+1), '─')
#= 0;                         idx= 1             /*initialize # of Sundaram primes & IDX*/
$=                                               /*a list of Sundaram primes  (so far). */
       do j=1  until #==n                        /*display the output (if cols > 0).    */
       if @.j\==.  then iterate                  /*Is the number not prime?  Then skip. */
       #= # + 1                                  /*bump number of Sundaram primes found.*/
       a= j                                      /*save J for calculating the Nth prime.*/
       if cols<=0  then iterate                  /*Build the list  (to be shown later)? */
       c= commas(j + j + 1)                      /*maybe add commas to  Sundaram  prime.*/
       $= $  right(c, max(w, length(c) ) )       /*add Sundaram prime──►list, allow big#*/
       if #//cols\==0  then iterate              /*have we populated a line of output?  */
       say center(idx, 7)'│'  substr($, 2);  $=  /*display what we have so far  (cols). */
       idx= idx + cols                           /*bump the  index  count for the output*/
       end   /*j*/

if $\==''  then say center(idx, 7)"│"  substr($, 2)  /*possible display residual output.*/
if cols>0  then say '───────┴'center(""   ,  1 + cols*(w+1), '─')
say
say 'found ' commas(#)  " Sundaram primes, and the last Sundaram prime is "  commas(a+a+1)
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
