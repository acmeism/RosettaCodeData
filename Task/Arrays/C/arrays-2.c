#include "arrays.h"

int main(int argc, char** argv)
{
arr    (int  , 10)   A2 = { 1, 2, 0 }; /* the rest of elements get the value 0 */
vla    (float    )   FV = {1.2, 2.5, 3.333, 4.92, 11.2, 22.0 }; /* automatically sizes */
vec_ext(float,  5) simd = {1,2,3,4,5}; /* aligned as 8x4=32bytes */
vec_ext(int  ,  3)   B2 = perm3(A2,2,1,0);

/* print elements of B2 */
printf("B2     : %d %d %d\n", B2[0],B2[1],B2[2]);
/* print size and alignment of array A2 */
printf("arr    : %zu/%zu/%2zu sum: %d\n", countof(A2  ), alignof(int  ), alignof(A2  ), sum(A2  ,3,0));
/* print size and alignment of VLA FV */
printf("vla    : %zu/%zu/%2zu sum: %f\n", countof(FV  ), alignof(float), alignof(FV  ), sum(FV  ,6,0));
/* print size and alignment of Vecor Extension simd */
printf("vec_ext: %zu/%zu/%2zu sum: %f\n", countof(simd), alignof(float), alignof(simd), sum(simd,5,0));

exit(EXIT_SUCCESS);
}
