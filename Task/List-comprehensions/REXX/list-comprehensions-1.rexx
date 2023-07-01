/*REXX program displays a vertical list of Pythagorean triples up to a specified number.*/
parse arg n .                                    /*obtain optional argument from the CL.*/
if n=='' | n==","  then n= 100                   /*Not specified?  Then use the default.*/
say  'Pythagorean triples  (a² + b² = c²,   c ≤'  n"):"     /*display the list's title. */
$=                                               /*assign a  null  to the triples list. */
            do     a=1   for n-2;  aa=a*a
              do   b=a+1  to n-1;  ab=aa + b*b
                do c=b+1  to n  ;  cc= c*c
                if ab<cc   then leave            /*Too small?   Then try the next  B.   */
                if ab==cc  then do;  $=$  '{'a","   ||   b','c"}";  leave;  end
                end   /*c*/
              end     /*b*/
            end       /*a*/
#= words($);                       sat
            do j=1  for #
            say  left('', 20)      word($, j)    /*display  a  member  of the list,     */
            end       /*j*/                      /* [↑]   list the members vertically.  */
say
say #  ' members listed.'                        /*stick a fork in it,  we're all done. */
