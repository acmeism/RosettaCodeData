#include <stdbool.h>
#include <stdio.h>
#include <string.h>

void memoizeIsPrime( bool * result, const int N )
{
    result[2] = true;
    result[3] = true;
    int prime[N];
    prime[0] = 3;
    int end = 1;
    for (int n = 5; n < N; n += 2)
    {
        bool n_is_prime = true;
        for (int i = 0; i < end; ++i)
        {
            const int PRIME = prime[i];
            if (n % PRIME == 0)
            {
                n_is_prime = false;
                break;
            }
            if (PRIME * PRIME > n)
            {
                break;
            }
        }
        if (n_is_prime)
        {
            prime[end++] = n;
            result[n] = true;
        }
    }
}/* memoizeIsPrime */

int sumOfDecimalDigits( int n )
{
    int sum = 0;
    while (n > 0)
    {
        sum += n % 10;
        n /= 10;
    }
    return sum;
}/* sumOfDecimalDigits */

int main( void )
{
    const int N = 500;

    printf( "Rosetta Code: additive primes less than %d:\n", N );

    bool is_prime[N];
    memset( is_prime, 0, sizeof(is_prime) );
    memoizeIsPrime( is_prime, N );

    printf( "   2" );
    int count = 1;
    for (int i = 3; i < N; i += 2)
    {
        if (is_prime[i] && is_prime[sumOfDecimalDigits( i )])
        {
            printf( "%4d", i );
            ++count;
            if ((count % 10) == 0)
            {
                printf( "\n" );
            }
        }
    }
    printf( "\nThose were %d additive primes.\n", count );
    return 0;
}/* main */
