/*REXX program shows a horizontal list of Pythagorean triples up to a specified number. */
parse arg n .                                    /*obtain optional argument from the CL.*/
if n=='' | n==","  then n= 100                   /*Not specified?  Then use the default.*/
            do k=1  for n;   @.k= k*k            /*precompute the squares of usable #'s.*/
            end   /*k*/
sw= linesize() - 1                               /*obtain the terminal width (less one).*/
say  'Pythagorean triples  (a² + b² = c²,   c ≤'  n"):"     /*display the list's title. */
$=                                               /*assign a  null  to the triples list. */
            do     a=1  for n-2;      bump= a//2 /*Note:   A*A   is faster than   A**2. */
              do b=a+1  to  n-1  by 1+bump
              ab= @.a + @.b                      /*AB: a shortcut for the sum of A² & B²*/
              if bump==0 & b//2==0  then cump= 2
                                    else cump= 1
                do c=b+cump  to n by  cump
                if ab<@.c   then leave           /*Too small?   Then try the next  B.   */
                if ab==@.c  then do;  $=$  '{'a","   ||   b','c"}";  leave;  end
                end   /*c*/
              end     /*b*/
            end       /*a*/
#= words($);                     say
            do j=1  until p==0;             p= lastPos('}', $, sw)    /*find the last } */
            if p\==0  then do;   _= left($, p)
                                 say strip(_)
                                 $= substr($, p+1)
                           end
            end   /*j*/
say strip($);                    say
say #  ' members listed.'                        /*stick a fork in it,  we're all done. */
