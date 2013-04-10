/*REXX program to show anonymous recursion  (of a function/subroutine). */
numeric digits 1e6                     /*in case the user goes kaa-razy.*/

       do j=0  to word(arg(1) 12, 1)   /*use argument or the default: 12*/
       say 'fibonacci('j") =" fib(j)   /*show Fibonacci sequence: 0──►x */
       end  /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────subroutines─────────────────────────*/
fib: procedure;  if arg(1)>=0  then return .(arg(1))
     say "***error!*** argument can't be negative.";   exit
.:procedure;  arg _;   if _<2 then return _;   return .(_-1)+.(_-2)
