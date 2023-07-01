/*REXX program  sums  the  decimal digits  of  integers  expressed in base ten.         */
parse arg z                                      /*obtain optional argument from the CL.*/
if z='' | z=","  then z=copies(7, 108)           /*let's generate a pretty huge integer.*/
numeric digits 1 + max( length(z) )              /*enable use of gigantic numbers.      */

     do j=1  for words(z);    _=abs(word(z, j))  /*ignore any leading sign,  if present.*/
     say sumDigs(_)      ' is the sum of the digits for the number '    _
     end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
sumDigs: procedure;  parse arg N 1 $ 2 ?         /*use first decimal digit for the sum. */
                             do  while ?\=='';  parse var ? _ 2 ?;  $=$+_;  end  /*while*/
         return $
