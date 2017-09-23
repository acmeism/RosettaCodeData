/*REXX program displays a vertical list of Pythagorean triples up to a specified number.*/
parse arg n .                                    /*get the optional argument from the CL*/
if n=='' | n==","  then n=100                    /*Not specified?  Then use the default.*/
say  'Pythagorean triples  (a² + b² = c²,   c ≤'  n"):"     /*display the list's title. */
$=                                               /*assign a  null  to the triples list. */
             do     a=1   for n-2;  aa=a*a       /*Note:  A*A is faster than A**2, but  */
               do   b=a+1  to n-1;  aabb=aa+b*b  /*                 ··· but not by much.*/
                 do c=b+1  to n
                 if aabb==c*c  then $=$  '{'a","   ||   b','c"}"
                 end   /*c*/
               end     /*b*/
             end       /*a*/
#=words($)
             do j=1  for #
             say left('', 20)  word($, j)        /*display  a  member  of the list,     */
             end       /*j*/                     /* [↑]   list the members vertically.  */
say #  'members listed.'                         /*stick a fork in it,  we're all done. */
