/*REXX program to show anonymous recursion  (of a function or subroutine).              */
numeric digits 1e6                               /*in case the user goes ka-razy.       */
parse arg x .                                    /*obtain the optional argument from CL.*/
if x=='' | x==","  then x=12                     /*Not specified?  Then use the default.*/
w=length(x)                                      /*W:  used for formatting the output.  */
                do j=0  to x;   jj=right(j, w)   /*use the  argument  as an upper limit.*/
                say 'fibonacci('jj") ="  fib(j)  /*show the Fibonacci sequence: 0 ──► x */
                end  /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
fib: procedure; parse arg z;  if z>=0  then return .(z)
                              say "***error***  argument can't be negative.";   exit
.:   procedure; parse arg #;  if #<2  then return #;              return .(#-1)  +  .(#-2)
