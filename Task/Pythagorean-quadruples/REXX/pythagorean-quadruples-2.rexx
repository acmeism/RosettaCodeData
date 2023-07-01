/*REXX pgm computes/shows (integers),  D  that aren't possible for: a² + b² + c²  =  d² */
parse arg hi .                                   /*obtain optional argument from the CL.*/
if hi=='' | hi==","  then hi=2200                /*Not specified?  Then use the default.*/
high= hi * 3                                     /*D  can be three times the  HI  (max).*/
@.= .                                            /*array of integers  (≤ hi)    squared.*/
      do s=1  for high;  _= s*s;  r._= s;  @.s=_ /*precompute squares and square roots. */
      end  /*s*/
!.=                                              /*array of differences between squares.*/
      do    c=1   for high;       cc = @.c       /*precompute possible differences.     */
         do d=c+1  to high;       dif= @.d - cc  /*process  D  squared; calc differences*/
         !.dif= !.dif cc                         /*add    CC    to the    !.DIF   list. */
         end   /*d*/
      end      /*c*/
d.=.                                             /*array of the possible solutions (D). */
      do     a=1  for hi-2                       /*go hunting for solutions to equation.*/
         do  b=a   to hi-1;        ab= @.a + @.b /*calculate sum of two  (A,B)  squares.*/
         if !.ab==''  then iterate               /*Not a difference?   Then ignore it.  */
            do n=1  for words(!.ab)              /*handle all ints that satisfy equation*/
            abc= ab  +  word(!.ab, n)            /*add the  C²  integer  to  A²  +  B²  */
            _= r.abc                             /*retrieve the square root  of  C²     */
            d._=                                 /*mark the  D  integer as being found. */
            end   /*n*/
         end      /*b*/
      end         /*a*/
say
say 'Not possible positive integers for   d ≤' hi "  using equation:  a² + b² + c²  =  d²"
say
$=                                               /* [↓]  find all the  "not possibles". */
       do p=1  for hi;   if d.p==.  then $= $ p  /*Not possible? Then add it to the list*/
       end   /*p*/                               /* [↓]  display list of not-possibles. */
say substr($, 2)                                 /*stick a fork in it,  we're all done. */
