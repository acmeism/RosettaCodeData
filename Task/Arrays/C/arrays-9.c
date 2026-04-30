#define XSIZE 20
double *kernel = malloc(sizeof(double)*2*XSIZE+1);
if (kernel) {
   kernel += XSIZE;
   for (ix=-XSIZE; ix<=XSIZE; ix++) {
       kernel[ix] = f(ix);
   ....
   free(kernel-XSIZE);
   }
}
