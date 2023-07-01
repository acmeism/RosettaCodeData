/*REXX program computes the dot product of two equal size vectors (of any size).*/
vectorA =  '  1   3  -5  '               /*populate vector  A  with some numbers*/
vectorB =  '  4  -2  -1  '               /*    "       "    B    "    "     "   */
Say  'vector A =' vectorA                /*display the elements of vector A.    */
Say  'vector B =' vectorB                /*   "     "     "      "   "    B.    */
p=dot_product(vectorA,vectorB)           /*invoke function & compute dot product*/
Say                                      /*display a blank line for readability.*/
Say 'dot product =' p                    /*display the dot product              */
Exit                                     /*stick a fork in it,  we're all done. */
/*------------------------------------------------------------------------------*/
dot_product:                             /* compute the dot product             */
  Parse Arg A,B
  /* Begin Error Checking                                                       */
  If words(A)<>words(B) Then
    Call exit 'Vectors aren''t the same size:' words(A) '<>' words(B)
  Do i=1 To words(A)
    If datatype(word(A,i))<>'NUM' Then
      Call exit 'Element' i 'of vector A isn''t a number:' word(A,i)
    If datatype(word(B,i))<>'NUM' Then
      Call exit 'Element' i 'of vector B isn''t a number:' word(B,i)
    End
  /* End Error Checking                                                         */
  product=0                              /* initialize the  sum  to   0  (zero).*/
  Do i=1 To words(A)
    product=product+word(A,i)*word(B,i)  /*multiply corresponding numbers       */
    End
  Return product
exit:
  Say '***error***' arg(1)
  Exit 13
