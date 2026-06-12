/*REXX program displays the first  N  product of divisors  (shown in a columnar format).*/
numeric digits 20                                /*ensure enough decimal digit precision*/
parse arg n cols .                               /*obtain optional argument from the CL.*/
if    n=='' |    n==","  then    n= 50           /*Not specified?  Then use the default.*/
if cols=='' | cols==","  then cols=  5           /* "      "         "   "   "     "    */
say ' index │'center("product of divisors", 102)       /*display title for the column #s*/
say '───────┼'center(""                   , 102,'─')   /*   "      "   separator (above)*/
w= max(20, length(n) )                           /*W:  used to align 1st output column. */
$=;                            idx= 1            /*$:  the output list, shown in columns*/
       do j=1  for N                             /*process  N  positive integers.       */
       $= $  ||  right( commas( sigma(j) ), 20)  /*add a sigma (sum) to the output list.*/
       if j//cols\==0  then iterate              /*Not a multiple of cols? Don't display*/
       say center(idx, 7)'│'             $       /*display partial list to the terminal.*/
       idx= idx + cols                           /*bump the index number for the output.*/
       $=                                        /*start with a blank line for next time*/
       end   /*j*/

if $\==''  then say center(idx, 7)' '    $       /*any residuals sums left to display?  */
say '───────┴'center(""                   , 102,'─')   /*   "      "   separator (above)*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
/*──────────────────────────────────────────────────────────────────────────────────────*/
sigma: procedure; parse arg x; if x==1 then return 1;  odd=x // 2    /* // ◄──remainder.*/
       p= x                                      /* [↓]  only use  EVEN or ODD integers.*/
             do k=2+odd  by 1+odd  while k*k<x   /*divide by all integers up to  √x.    */
             if x//k==0  then p= p * k * (x % k) /*multiple the two divisors to product.*/
             end   /*k*/                         /* [↑]  %  is the REXX integer division*/
       if k*k==x  then  return p * k             /*Was  X  a square?   If so, add  √ x  */
                        return p                 /*return (sigma) sum of the divisors.  */
