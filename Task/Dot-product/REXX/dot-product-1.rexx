/*REXX program  computes  the   dot product   of  two equal size vectors  (of any size).*/
                     vectorA =  '  1   3  -5  '  /*populate vector  A  with some numbers*/
                     vectorB =  '  4  -2  -1  '  /*    "       "    B    "    "     "   */
say  'vector A = '   vectorA                     /*display the elements in the vector A.*/
say  'vector B = '   vectorB                     /*   "     "     "      "  "    "    B.*/
p=.Prod(vectorA, vectorB)                        /*invoke function & compute dot product*/
say                                              /*display a blank line for readability.*/
say  'dot product = '   p                        /*display the dot product to terminal. */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
.Prod:  procedure;  parse arg A,B                /*this function compute the dot product*/
        $=0                                      /*initialize the sum to  0 (zero).     */
                    do j=1  for words(A)         /*multiply each number in the vectors. */
                    $=$+word(A,j) * word(B,j)    /*  ··· and add the product to the sum.*/
                    end   /*j*/
        return $                                 /*return the sum to function's invoker.*/
