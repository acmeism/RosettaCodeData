/*REXX program sums the decimal digits of integers expressed in base ten*/
parse arg z                            /*get optional #s or use default.*/
if z=''  then z=copies(7, 108)         /*let's generate a pretty huge #.*/
numeric digits 1+max(length(z))        /*enable use of gigantic numbers.*/

     do j=1  for words(z);     _=abs(word(z,j))   /*ignore sign, if any.*/
     say sumDigs(_)      ' is the sum of the digits for the number '  _
     end   /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SUMDIGS subroutine──────────────────*/
sumDigs: procedure;  parse arg N 1 s 2 ?    /*use first dig for S (sum),*/
                 do  while ?\=='';  parse var ? _ 2 ?;  s=s+_;  end  /*k*/
return s
