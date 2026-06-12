/*REXX pgm computes integers A, B, C  that solve:  0<A<B<C; A+B+C = 1000; A^2+B^2 = C^2 */
parse arg sum hi n .                             /*obtain optional argument from the CL.*/
if sum=='' | sum==","  then sum= 1000            /*Not specified?  Then use the default.*/
if  hi=='' |  hi==","  then  hi= 1000            /* "      "         "   "   "     "    */
if   n=='' |   n==","  then   n=    1            /* "      "         "   "   "     "    */
hh= hi - 2                                       /*N:  number of solutions to find/show.*/
                    do j=1  for hi;    @.j= j*j  /*pre─compute squares ──► HI, inclusive*/
                    end  /*j*/
#= 0;                           pad= left('', 9) /*#:  the number of solutions found.   */
     do       a=2    for hh%2  by 2;   aa= @.a   /*search for solutions to the equations*/
        do    b=a+1;                   ab= a + b /*compute the sum of 2 numbers (A & B).*/
        if ab>hh          then iterate a         /*Sum of A+B>HI?    Then stop with B's */
        aabb= aa + @.b                           /*compute the sum of:   A^2  +  B^2    */
           do c=b+1  while @.c <= aabb           /*test integers that satisfy equations.*/
           if @.c\==aabb  then iterate           /*   "  \=A^2+B^2?  Then keep searching*/
           abc= ab + c                           /*compute the sum of:   A  +  B  +  C  */
           if abc >  sum  then iterate b         /*Is  A+B+C > SUM?  Then stop with C's.*/
           if abc == sum  then call show         /*Does  "   = SUM?  Then solution found*/
           end   /*c*/
        end      /*b*/
     end         /*a*/
done:              if #==0  then #= 'no';  say pad pad pad   #   ' solution's(#)  "found."
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
s:     if arg(1)==1  then return arg(3);  return word(arg(2) 's', 1) /*simple pluralizer*/
show:  #= #+1;  say pad 'a=' a pad  "b=" b pad  'c=' c;  if #>=n  then signal done; return
