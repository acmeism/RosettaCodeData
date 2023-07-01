#include <assert.h>

int main(){
   int a;
   /* ...input or change a here */
   assert(a == 42); /* aborts program when a is not 42, unless the NDEBUG macro was defined */

   return 0;
}
