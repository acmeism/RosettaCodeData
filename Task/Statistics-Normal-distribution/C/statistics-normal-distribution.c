/*
 * RosettaCode example: Statistics/Normal distribution in C
 *
 * The random number generator rand() of the standard C library is obsolete
 * and should not be used in more demanding applications. There are plenty
 * libraries with advanced features (eg. GSL) with functions to calculate
 * the mean, the standard deviation, generating random numbers etc.
 * However, these features are not the core of the standard C library.
 */
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <time.h>


#define NMAX 10000000


double mean(double* values, int n)
{
    int i;
    double s = 0;

    for ( i = 0; i < n; i++ )
        s += values[i];
    return s / n;
}


double stddev(double* values, int n)
{
    int i;
    double average = mean(values,n);
    double s = 0;

    for ( i = 0; i < n; i++ )
        s += (values[i] - average) * (values[i] - average);
    return sqrt(s / (n - 1));
}

/*
 * Normal random numbers generator - Marsaglia algorithm.
 */
double* generate(int n)
{
    int i;
    int m = n + n % 2;
    double* values = (double*)calloc(m,sizeof(double));
    double average, deviation;

    if ( values )
    {
        for ( i = 0; i < m; i += 2 )
        {
            double x,y,rsq,f;
            do {
                x = 2.0 * rand() / (double)RAND_MAX - 1.0;
                y = 2.0 * rand() / (double)RAND_MAX - 1.0;
                rsq = x * x + y * y;
            }while( rsq >= 1. || rsq == 0. );
            f = sqrt( -2.0 * log(rsq) / rsq );
            values[i]   = x * f;
            values[i+1] = y * f;
        }
    }
    return values;
}


void printHistogram(double* values, int n)
{
    const int width = 50;
    int max = 0;

    const double low   = -3.05;
    const double high  =  3.05;
    const double delta =  0.1;

    int i,j,k;
    int nbins = (int)((high - low) / delta);
    int* bins = (int*)calloc(nbins,sizeof(int));
    if ( bins != NULL )
    {
        for ( i = 0; i < n; i++ )
        {
            int j = (int)( (values[i] - low) / delta );
            if ( 0 <= j  &&  j < nbins )
                bins[j]++;
        }

        for ( j = 0; j < nbins; j++ )
            if ( max < bins[j] )
                max = bins[j];

        for ( j = 0; j < nbins; j++ )
        {
            printf("(%5.2f, %5.2f) |", low + j * delta, low + (j + 1) * delta );
            k = (int)( (double)width * (double)bins[j] / (double)max );
            while(k-- > 0) putchar('*');
            printf("  %-.1f%%", bins[j] * 100.0 / (double)n);
            putchar('\n');
        }

        free(bins);
    }
}


int main(void)
{
    double* seq;

    srand((unsigned int)time(NULL));

    if ( (seq = generate(NMAX)) != NULL )
    {
        printf("mean = %g, stddev = %g\n\n", mean(seq,NMAX), stddev(seq,NMAX));
        printHistogram(seq,NMAX);
        free(seq);

        printf("\n%s\n", "press enter");
        getchar();
        return EXIT_SUCCESS;
    }
    return EXIT_FAILURE;
}
