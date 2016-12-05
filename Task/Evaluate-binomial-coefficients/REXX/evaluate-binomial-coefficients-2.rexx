/*REXX program calculates   binomial coefficients  (also known as  combinations).       */
numeric digits 100000                            /*be able to handle gihugeic numbers.  */
parse arg n k .                                  /*obtain  N  and  K   from the C.L.    */
say 'combinations('n","k')='  comb(n,k)          /*display the number of combinations.  */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
comb:  procedure;  parse arg x,y;        return pfact(x-y+1, x)  %  pfact(2, y)
/*──────────────────────────────────────────────────────────────────────────────────────*/
pfact: procedure;  !=1;        do j=arg(1)  to arg(2);  !=!*j;  end  /*j*/;       return !
