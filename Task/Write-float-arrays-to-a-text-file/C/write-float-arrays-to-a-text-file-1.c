#include <stdio.h>
#include <math.h>

int main(int argc, char **argv) {

   float x[4] = {1,2,3,1e11}, y[4];
   int i = 0;
   FILE *filePtr;

   filePtr = fopen("floatArray","w");

   for (i = 0; i < 4; i++) {
      y[i] = sqrt(x[i]);
      fprintf(filePtr, "%.3g\t%.5g\n", x[i], y[i]);
   }

   return 0;
}
