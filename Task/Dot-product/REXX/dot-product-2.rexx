/*REXX program  computes  the   dot product   of  two equal size vectors  (of any size).*/
vectorA =   '  1   3  -5  '                      /*populate vector  A  with some numbers*/
vectorB =   '  4  -2  -1  '                      /*    "       "    B    "    "     "   */
say                                              /*display a blank line for readability.*/
say  'vector A = '   vectorA                     /*display the elements in the vector A.*/
say  'vector B = '   vectorB                     /*   "     "     "      "  "    "    B.*/
p=.prod(vectorA, vectorB)                        /*invoke function & compute dot product*/
say                                              /*display a blank line for readability.*/
say  'dot product = '   p                        /*display the dot product to terminal. */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
ser:   say "***error*** vector "   @.k   ' element'  j  " isn't numeric: "  n.k;   exit 13
/*──────────────────────────────────────────────────────────────────────────────────────*/
.prod: procedure;  parse arg A,B                 /*this function compute the dot product*/
       lenA = words(A);           @.1= 'A'       /*the number of numbers in vector  A.  */
       lenB = words(B);           @.2= 'B'       /* "     "    "    "     "    "    B.  */
                                                 /*Also, define 2 literals to hold names*/
       if lenA\==lenB  then do;   say "***error*** vectors aren't the same size:" /*oops*/
                                  say '            vector  A  length = '   lenA
                                  say '            vector  B  length = '   lenB
                                  exit 13        /*exit pgm with bad─boy return code 13.*/
                            end
       $=0                                       /*initialize the  sum  to   0  (zero). */
                 do j=1  for lenA                /*multiply each number in the vectors. */
                 #.1=word(A,j)                   /*use array to hold 2 numbers at a time*/
                 #.2=word(B,j)
                                  do k=1  for 2;   if \datatype(#.k,'N')  then call ser
                                  end   /*k*/
                 $=$ + #.1 * #.2                 /*  ··· and add the product to the sum.*/
                 end      /*j*/
       return $                                  /*return the sum to invoker of function*/
