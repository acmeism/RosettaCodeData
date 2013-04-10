/*REXX program computes the  dot product  of  two equal size vectors.   */
vectorA =   '  1   3  -5 '             /*populate vectorA with numbers, */
vectorB =   '  4  -2  -1 '             /* ∙∙∙ and the same for vectorB. */
say                                    /*display a blank line.          */
say 'vector A='vectorA                 /*echo the  vectorA's  values.   */
say 'vector B='vectorB                 /*echo the  vectorB's  values.   */
say                                    /*display another blank line.    */
p = dotProd(vectorA, vectorB)          /*go and compute the dot product.*/
say 'dot product = '   p               /*show and tell the dot product. */
say                                    /*display another a blank line.  */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────DOTPROD subroutine──────────────────*/
dotProd:  procedure;   parse arg A,B   /*compute the dot product.       */
sum = 0                                /*initilize the sum to 0 (zero). */
lenA = words(A)                        /*length of  vector A  in words. */
lenB = words(B)                        /*length of  vector B  in words. */

if lenA\==lenB  then do
                     say
                     say '*** error! ***'
                     say "vectors aren't the same size:"
                     say 'vectorA length='lenA
                     say 'vectorB length='lenB
                     say
                     exit 13           /*exit with  return code 13.     */
                     end

  do j=1  for lenA                     /*multiply each number in vectors*/
  sum = sum +   word(A,j) * word(B,j)  /*∙∙∙ and add the product to SUM.*/
  end   /*j*/

return sum                             /*return the SUM to the invoker. */
