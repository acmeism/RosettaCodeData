/* allocate an array of n MyTypes */
MyType var = calloc(n, sizeof(sMyType));

MyType third = var+3;       /* a reference to the 3rd item allocated */

MyType fourth = &var[4];    /* another way, getting the fourth item */
