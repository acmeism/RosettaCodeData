/*REXX program to show anonymous recursion  (of a function or subroutine).              */
numeric digits 1e6                               /*in case the user goes ka-razy with X.*/
parse arg x .                                    /*obtain the optional argument from CL.*/
if x=='' | x==","  then x=12                     /*Not specified?  Then use the default.*/
w=length(x)                                      /*W:  used for formatting the output.  */
                   do j=0  for x+1               /*use the  argument  as an upper limit.*/
                   say 'fibonacci('right(j, w)") ="   fib(j)
                   end  /*j*/                    /* [↑] show Fibonacci sequence: 0 ──► X*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
fib: procedure; parse arg z;  if z>=0  then return .(z)
                              say "***error***  argument can't be negative.";   exit
.:   procedure; parse arg #;  if #<2  then return #;              return .(#-1)  +  .(#-2)
