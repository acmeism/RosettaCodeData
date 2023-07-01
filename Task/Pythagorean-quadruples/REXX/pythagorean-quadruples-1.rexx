/*REXX pgm computes/shows (integers),  D  that aren't possible for: a² + b² + c²  =  d² */
parse arg hi .                                   /*obtain optional argument from the CL.*/
if hi=='' | hi==","  then hi=2200;  high= 3 * hi /*Not specified?  Then use the default.*/
@.=.                                             /*array of integers to be squared.     */
!.=.                                             /*  "    "     "    squared.           */
       do j=1  for high                          /*precompute possible squares (to max).*/
       _= j*j;   !._= j;   if j<=hi  then @.j= _ /*define a square; D  value; squared # */
       end   /*j*/
d.=.                                             /*array of possible solutions  (D)     */
       do       a=1  for hi-2;  aodd= a//2       /*go hunting for solutions to equation.*/
          do    b=a   to hi-1;
          if aodd  then  if b//2  then iterate   /*Are  A  and  B  both odd?  Then skip.*/
          ab = @.a + @.b                         /*calculate sum of  2  (A,B)   squares.*/
             do c=b   to hi;     abc= ab  + @.c  /*    "      "   "  3  (A,B,C)    "    */
             if !.abc==.  then iterate           /*Not a square? Then skip it*/
             s=!.abc;    d.s=                    /*define this D solution as being found*/
             end   /*c*/
          end      /*b*/
       end         /*a*/
say
say 'Not possible positive integers for   d ≤' hi "  using equation:  a² + b² + c²  =  d²"
say
$=                                               /* [↓]  find all the  "not possibles". */
       do p=1  for hi;   if d.p==.  then $=$ p   /*Not possible? Then add it to the list*/
       end   /*p*/                               /* [↓]  display list of not-possibles. */
say substr($, 2)                                 /*stick a fork in it,  we're all done. */
