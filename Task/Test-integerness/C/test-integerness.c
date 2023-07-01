#include <stdio.h>
#include <complex.h>
#include <math.h>

/* Testing macros */
#define FMTSPEC(arg) _Generic((arg), \
    float: "%f", double: "%f", \
    long double: "%Lf", unsigned int: "%u", \
    unsigned long: "%lu", unsigned long long: "%llu", \
    int: "%d", long: "%ld", long long: "%lld", \
    default: "(invalid type (%p)")

#define CMPPARTS(x, y) ((long double complex)((long double)(x) + \
            I * (long double)(y)))

#define TEST_CMPL(i, j)\
    printf(FMTSPEC(i), i), printf(" + "), printf(FMTSPEC(j), j), \
    printf("i = %s\n", (isint(CMPPARTS(i, j)) ? "true" : "false"))

#define TEST_REAL(i)\
    printf(FMTSPEC(i), i), printf(" = %s\n", (isint(i) ? "true" : "false"))

/* Main code */
static inline int isint(long double complex n)
{
    return cimagl(n) == 0 && nearbyintl(creall(n)) == creall(n);
}

int main(void)
{
    TEST_REAL(0);
    TEST_REAL(-0);
    TEST_REAL(-2);
    TEST_REAL(-2.00000000000001);
    TEST_REAL(5);
    TEST_REAL(7.3333333333333);
    TEST_REAL(3.141592653589);
    TEST_REAL(-9.223372036854776e18);
    TEST_REAL(5e-324);
    TEST_REAL(NAN);
    TEST_CMPL(6, 0);
    TEST_CMPL(0, 1);
    TEST_CMPL(0, 0);
    TEST_CMPL(3.4, 0);

    /* Demonstrating that we can use the same function for complex values
     * constructed in the standard way */
    double complex test1 = 5 + 0*I,
                   test2 = 3.4f,
                   test3 = 3,
                   test4 = 0 + 1.2*I;

    printf("Test 1 (5+i) = %s\n", isint(test1) ? "true" : "false");
    printf("Test 2 (3.4+0i) = %s\n", isint(test2) ? "true" : "false");
    printf("Test 3 (3+0i) = %s\n", isint(test3) ? "true" : "false");
    printf("Test 4 (0+1.2i) = %s\n", isint(test4) ? "true" : "false");
}
