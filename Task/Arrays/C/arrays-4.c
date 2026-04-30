When defining autosized multidimensional arrays, all the dimensions except the first (leftmost) need to be defined. This is required in order for the compiler to generate the proper indexing for the array.
<syntaxhighlight lang="c">long a2D_Array[3][5];    /* 3 rows, 5 columns. */
float my2Dfloats[][3] = {
   1.0, 2.0, 0.0,
   5.0, 1.0, 3.0 };
printf("rows: %zu\n",countof(my2Dfloats)); /* print row count */
