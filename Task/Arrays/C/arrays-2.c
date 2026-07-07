#include "arrays.h"

int main(int argc, char** argv)
{
arr            (10,  int)   A2 = { 1, 2, 0 }; /* the rest of elements get the value 0 */
alignas(32) vec( 5,float) simd = {1,2,3,4,5}; /* aligned as 8x4=32bytes */
vec            ( 3,  int)   B2 = vperm(A2,2,1,0);

vout("B2:   ",B2  , "                            ",  3,true); sout(" sum: ",vsum( 3,   B2,   int,0),""); eout();
vout("A2:   ",A2  , "",  5,true); sout(" sum: ",vsum(10,   A2,   int,0),""); eout();
vout("simd: ",simd, "",  5,true); sout(" sum: ",vsum( 5, simd, float,0),""); eout();

exit(EXIT_SUCCESS);
}
