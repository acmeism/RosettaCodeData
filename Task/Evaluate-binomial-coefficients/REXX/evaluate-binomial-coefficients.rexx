/*REXX program calculates   binomial coefficients  (aka, combinations). */

numeric digits 100000
parse arg n k .
say 'combinations('n","k') =' comb(n,k)
exit                                   /*stick a fork in it, we're done.*/

/*──────────────────────────────────COMB subroutine─────────────────────*/
comb: procedure;  parse arg x,y;   return fact(x) / (fact(x-y) * fact(y))

/*──────────────────────────────────FACT subroutine─────────────────────*/
fact: procedure; parse arg z;  !=1;    do j=2 to z;  !=!*j;  end; return !
