int* myFuncComplex( double* (*funcParameter)(long* parameter) )
{
     long inLong;
     double* outDouble;
     long *inLong2 = &inLong;

     /* ... */

     outDouble = (*funcParameter)(&inLong);  /* Call the passed function and store returned pointer. */
     outDouble = funcParameter(inLong2);     /* Same as above with slight different syntax. */

     /* ... */
}
