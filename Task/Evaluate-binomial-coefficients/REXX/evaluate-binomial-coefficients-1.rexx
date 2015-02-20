/*REXX program calculates   binomial coefficients  (aka, combinations). */
numeric digits 100000                  /*allow some gihugeic numbers.   */
parse arg n k .                        /*get   N  and  K   from the C.L.*/
say 'combinations('n","k')=' comb(n,k) /*display the result to terminal.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────COMB subroutine─────────────────────*/
comb: procedure;  parse arg x,y;    return fact(x) % (fact(x-y) * fact(y))
/*──────────────────────────────────FACT subroutine─────────────────────*/
fact: procedure;  !=1;    do j=2  to arg(1);  !=!*j;  end;        return !
