/*REXX program detects a  cycle  in an  iterated function  [F]  using a robust hashing. */
parse arg power .                                      /*obtain optional args from C.L. */
if power=='' | power=","  then power=8                 /*Not specified?  Use the default*/
numeric digits 500                                     /*be able to handle big numbers. */
divisor= 2**power - 1                                  /*compute the divisor, power of 2*/
numeric digits max(9, length(divisor) * 2 + 1)         /*allow for the  square  plus one*/
say '       power ='  power                            /*display the power   to the term*/
say '     divisor ='  "{2**"power'}-1 = '    divisor   /*   "     "  divisor. "  "    " */
say
x=3;    $=x;   $$=;      m=100;    !.=.;     !.x=1     /*M:  maximum numbers to display.*/

               do n=1+words($);    x= f(x);  $$=$$ x
               if n//2000==0  then do;   $=$ $$;   $$=;  end   /*Is a 2000th N?  Rejoin.*/
               if !.x\==.     then leave               /*is this number a repeat?  Leave*/
               !.x= n
               end   /*n*/                             /*N:   is the size of   $   list.*/
$= space($ $$)                                         /*append residual numbers to  $  */
if n<m  then say '  original list=' $ ...              /*maybe display the list to term.*/
             say 'numbers in list=' n                  /*display number of numbers.     */
             say '  cycle length =' n - !.x            /*display the cycle to the term. */
             say '  start index  =' !.x - 1   "  ◄─── zero based"      /*show the index.*/
if n<m  then say 'cycle sequence =' subword($, !.x, n- !.x) /*maybe display the sequence*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
f:   return ( arg(1) **2  +  1)   //   255       /*this defines/executes the function F.*/
