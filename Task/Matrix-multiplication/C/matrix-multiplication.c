#include <stdio.h>

#define MAT_ELEM(rows,cols,r,c) (r*cols+c)

//Improve performance by assuming output matrices do not overlap with
//input matrices. If this is C++, use the __restrict extension instead
#ifdef __cplusplus
    typedef double * const __restrict MAT_OUT_t;
#else
    typedef double * const restrict MAT_OUT_t;
#endif
typedef const double * const MAT_IN_t;

static inline void mat_mult(
    const int m,
    const int n,
    const int p,
    MAT_IN_t a,
    MAT_IN_t b,
    MAT_OUT_t c)
{
    for (int row=0; row<m; row++) {
        for (int col=0; col<p; col++) {
            c[MAT_ELEM(m,p,row,col)] = 0;
            for (int i=0; i<n; i++) {
                c[MAT_ELEM(m,p,row,col)] += a[MAT_ELEM(m,n,row,i)]*b[MAT_ELEM(n,p,i,col)];
            }
        }
    }
}

static inline void mat_show(
    const int m,
    const int p,
    MAT_IN_t a)
{
    for (int row=0; row<m;row++) {
        for (int col=0; col<p;col++) {
            printf("\t%7.3f", a[MAT_ELEM(m,p,row,col)]);
        }
        putchar('\n');
    }
}

int main(void)
{
    double a[4*4] = {1, 1,   1,   1,
                     2, 4,   8,  16,
                     3, 9,  27,  81,
                     4, 16, 64, 256};

    double b[4*3] = {    4.0,   -3.0,  4.0/3,
                     -13.0/3, 19.0/4, -7.0/3,
                       3.0/2,   -2.0,  7.0/6,
                      -1.0/6,  1.0/4, -1.0/6};

    double c[4*3] = {0};

    mat_mult(4,4,3,a,b,c);
    mat_show(4,3,c);
    return 0;
}
