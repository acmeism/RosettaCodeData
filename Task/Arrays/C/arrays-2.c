#include "arrays.h"

int main(int argc, char** argv)
{
arr            (10,  int)   A2 = { 1, 2, 0 }; /* the rest of elements get the value 0 */
alignas(32) vec( 5,float) simd = {1,2,3,4,5}; /* aligned as 8x4=32bytes */
vec            ( 3,  int)   B2 = perm3(A2,2,1,0);

/* print elements of B2 */
printf("B2 : %d %d %d\n", B2[0],B2[1],B2[2]);
/* print size and alignment of array A2 */
printf("arr: %zu/%zu/%2zu sum: %d\n", countof(A2  ), alignof(int  ), alignof(A2  ), sum(A2  ,3,0));
/* print size and alignment of Vecor Extension simd */
printf("vec: %zu/%zu/%2zu sum: %f\n", countof(simd), alignof(float), alignof(simd), sum(simd,5,0));

exit(EXIT_SUCCESS);
}
