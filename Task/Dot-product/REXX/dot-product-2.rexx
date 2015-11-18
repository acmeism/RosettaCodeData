/*REXX program computes the   dot product   of  two equal size vectors.       */
vectorA =   '  1   3  -5 '             /*populate vector  A  with some numbers*/
vectorB =   '  4  -2  -1 '             /*    "       "    B    "    "     "   */
say;   say  'vector A = '   vectorA    /*display the elements in the vector A.*/
       say  'vector B = '   vectorB    /*   "     "     "      "  "    "    B.*/
p=dotProd(vectorA, vectorB)            /*invoke function & compute dot product*/
say;   say  'dot product = '   p       /*blank line;  display the dot product.*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
dotProd:  procedure;   parse arg A,B   /*this function compute the dot product*/
lenA = words(A)                        /*the number of numbers in vector  A.  */
lenB = words(B)                        /* "     "    "    "     "    "    B.  */
e='***error!***  ';  @.='A';  @.2='B'  /*define some literals for error msgs. */

if lenA\==lenB  then do                                             /*oops─ay.*/
                     say e "vectors aren't the same size:"
                     say '       vector A length = ' lenA
                     say '       vector B length = ' lenB
                     exit 13           /*exit with  bad─boy  return code 13.  */
                     end
$=0                                    /*initialize the sum to  0 (zero).     */
          do j=1  for lenA             /*multiply each number in the vectors. */
          n.1=word(A,j);  n.2=word(B,j)

             do k=1  for 2;  notNum=\datatype(n.k,'Number')  /*verify numbers.*/
             if notNum  then do                              /*oops─ay, ¬ num.*/
                             say e "vector" @.k 'element' j "isn't numeric:" n.k
                             exit 13       /*exit with return code 13.*/
                             end
             end   /*k*/

          $=$+n.1 * n.2                /*  ··· and add the product to the sum.*/
          end      /*j*/
return $                               /*return the sum to invoker of function*/
