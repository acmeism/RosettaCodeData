/*REXX program to demonstrate some run-time evaulations.                */

a=fact(3)
b=fact(4)
say b-a
exit                                   /*stick a fork in it, we're done.*/

/*───────────────────────────────────FACT subroutine────────────────────*/
fact: procedure; parse arg n; !=1;   do j=2  to n;  !=!*j;  end;  return !
