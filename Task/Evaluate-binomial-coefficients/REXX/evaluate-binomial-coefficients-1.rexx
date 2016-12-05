/*REXX program calculates   binomial coefficients  (also known as  combinations).       */
numeric digits 100000                            /*be able to handle gihugeic numbers.  */
parse arg n k .                                  /*obtain  N  and  K   from the C.L.    */
say 'combinations('n","k')='  comb(n,k)          /*display the number of combinations.  */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
comb: procedure;  parse arg x,y;         return !(x) % (!(x-y) * !(y))
!:    procedure;  !=1;           do j=2  to arg(1);  !=!*j;  end  /*j*/;          return !
