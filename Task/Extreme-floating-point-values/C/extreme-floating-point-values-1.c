#include <stdio.h>

int main()
{
    double inf = 1/0.0;
    double minus_inf = -1/0.0;
    double minus_zero = -1/ inf ;
    double nan = 0.0/0.0;

    printf("positive infinity: %f\n",inf);
    printf("negative infinity: %f\n",minus_inf);
    printf("negative zero: %f\n",minus_zero);
    printf("not a number: %f\n",nan);

    /* some arithmetic */

    printf("+inf + 2.0 = %f\n",inf + 2.0);
    printf("+inf - 10.1 = %f\n",inf - 10.1);
    printf("+inf + -inf = %f\n",inf + minus_inf);
    printf("0.0 * +inf = %f\n",0.0 * inf);
    printf("1.0/-0.0 = %f\n",1.0/minus_zero);
    printf("NaN + 1.0 = %f\n",nan + 1.0);
    printf("NaN + NaN = %f\n",nan + nan);

    /* some comparisons */

    printf("NaN == NaN = %s\n",nan == nan ? "true" : "false");
    printf("0.0 == -0.0 = %s\n",0.0 == minus_zero ? "true" : "false");

    return 0;
}
