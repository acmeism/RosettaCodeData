/*REXX program counts the number of divisors (tau,  or sigma_0)  up to and including  N.*/
parse arg LO HI cols .                           /*obtain optional argument from the CL.*/
if   LO=='' |   LO==","  then  LO=   1           /*Not specified?  Then use the default.*/
if   HI=='' |   HI==","  then  HI=  LO + 100 - 1 /*Not specified?  Then use the default.*/
if cols=='' | cols==","  then cols= 20           /* "      "         "   "   "     "    */
w= 2 + (HI>45359)                                /*W:  used to align the output columns.*/
say 'The number of divisors  (tau)  for integers up to '    n    " (inclusive):";      say
say '─index─'   center(" tau (number of divisors) ",  cols * (w+1)  +  1,  '─')
$=;                                   c= 0       /*$:  the output list,  shown ROW/line.*/
                do j=LO  to HI;       c= c + 1   /*list # proper divisors (tau) 1 ──► N */
                $= $  right( tau(j), w)          /*add a tau number to the output list. */
                if c//cols \== 0  then iterate   /*Not a multiple of ROW? Don't display.*/
                idx= j - cols + 1                /*calculate index value (for this row).*/
                say center(idx, 7)    $;  $=     /*display partial list to the terminal.*/
                end   /*j*/

if $\==''  then say center(idx+cols, 7)    $     /*there any residuals left to display ?*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
tau: procedure; parse arg x 1 y                  /*X  and  $  are both set from the arg.*/
     if x<6  then return 2 + (x==4) - (x==1)     /*some low #s should be handled special*/
     odd= x // 2                                 /*check if  X  is odd (remainder of 1).*/
     if odd  then       #= 2                     /*Odd?    Assume divisor count of  2.  */
             else do;   #= 4;   y= x % 2;   end  /*Even?      "      "      "    "  4.  */
                                                 /* [↑]  start with known number of divs*/
        do j=3  for x%2-3  by 1+odd  while j<y   /*for odd number,  skip even numbers.  */
        if x//j==0  then do                      /*if no remainder, then found a divisor*/
                         #= # + 2;   y= x % j    /*bump # of divisors;  calculate limit.*/
                         if j>=y  then do;   #= # - 1;   leave;   end   /*reached limit?*/
                         end                     /*                     ___             */
                    else if j*j>x  then leave    /*only divide up to   √ x              */
        end   /*j*/;               return #      /* [↑]  this form of DO loop is faster.*/
