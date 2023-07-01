#include <stdio.h>
#include <math.h>
#include <complex.h>

int main()
{
	printf("0 ^ 0 = %f\n", pow(0,0));
        double complex c = cpow(0,0);
	printf("0+0i ^ 0+0i = %f+%fi\n", creal(c), cimag(c));
	return 0;
}
