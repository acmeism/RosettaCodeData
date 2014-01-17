/*REXX program computes the  dot product  of  two equal size vectors.   */
vectorA =   '  1   3  -5 '             /*populate vectorA with numbers, */
vectorB =   '  4  -2  -1 '             /* ∙∙∙ and the same for vectorB. */
say                                    /*display a blank line.          */
say 'vector A = ' vectorA              /*echo the elements in vector A. */
say 'vector B = ' vectorB              /*  "   "     "      "    "   B. */
say                                    /*display another blank line.    */
p = dotProd(vectorA, vectorB)          /*go and compute the dot product.*/
say 'dot product = '   p               /*show and tell the dot product. */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────DOTPROD subroutine──────────────────*/
dotProd:  procedure;   parse arg A,B   /*compute the dot product.       */
lenA = words(A)                        /*number of numbers in vector  A.*/
lenB = words(B)                        /*   "    "    "     "    "    B.*/
if lenA\==lenB  then do                /*are vectors unequal in size?   */
                     say '*** error! ***'
                     say "vectors aren't the same size:"
                     say '       vector A length = ' lenA
                     say '       vector B length = ' lenB
                     exit 13           /*exit with  return code 13.     */
                     end
sum=0                                  /*initialize the sum to 0 (zero).*/
           do j=1  for lenA            /*multiply each number in vectors*/
           sum=sum+word(A,j)*word(B,j) /*∙∙∙ and add the product to SUM.*/
           end   /*j*/
return sum                             /*return the SUM to the invoker. */
