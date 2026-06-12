/*REXX program displays the first   N   sum of divisors  (shown in a columnar format).  */
parse arg n cols .                               /*obtain optional argument from the CL.*/
if    n=='' |    n==","  then    n= 100          /*Not specified?  Then use the default.*/
if cols=='' | cols==","  then cols=  10          /* "      "         "   "   "     "    */
say ' index │'center("sum of divisors", 102)     /*display the title for the column #s. */
say '───────┼'center(""               , 102,'─') /*   "     "  separator for the title. */
w= 10                                            /*W:  used to align 1st output column. */
$=;                            idx= 1            /*$:  the output list, shown in columns*/
       do j=1  for N                             /*process  N  positive integers.       */
       $= $  ||  right( commas( sigma(j) ), w)   /*add a sigma (sum) to the output list.*/
       if j//cols\==0  then iterate              /*Not a multiple of cols? Don't display*/
       say center(idx, 7)'│'            $        /*display partial list to the terminal.*/
       idx= idx + cols                           /*bump the index number for the output.*/
       $=                                        /*start with a blank line for next line*/
       end   /*j*/

if $\==''  then say center(idx, 7)'│'   $        /*any residuals sums left to display?  */
say '───────┴'center(""               , 102,'─') /*   "     "  foot separator for data. */
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
/*──────────────────────────────────────────────────────────────────────────────────────*/
sigma: procedure; parse arg x; if x==1 then return 1;  odd=x // 2    /* // ◄──remainder.*/
       s= 1 + x                                  /* [↓]  only use  EVEN or ODD integers.*/
             do k=2+odd  by 1+odd  while k*k<x   /*divide by all integers up to  √x.    */
             if x//k==0  then  s= s + k +  x % k /*add the two divisors to (sigma) sum. */
             end   /*k*/                         /* [↑]  %  is the REXX integer division*/
       if k*k==x  then  return s + k             /*Was  X  a square?   If so, add  √ x  */
                        return s                 /*return (sigma) sum of the divisors.  */
