/*
 *  Ascending primes
 *
 *  Generate and show all primes with strictly ascending decimal digits.
 *
 *
 *  Solution
 *
 *  We only consider positive numbers in the range 1 to 123456789. We would
 *  get 7027260 primes, because there are so many primes smaller than 123456789
 *  (see also Wolfram Alpha).On the other hand, there are only 511 distinct
 *  nonzero positive integers having their digits arranged in ascending order.
 *  Therefore, it is better to start with numbers that have properly arranged
 *  digitsand then check if they are prime numbers.The method of generating
 *  a sequence of such numbers is not indifferent.We want this sequence to be
 *  monotonically increasing, because then additional sorting of results will
 *  be unnecessary. It turns out that by using a queue we can easily get the
 *  desired effect. Additionally, the algorithm then does not use recursion
 *  (although the program probably does not have to comply with the MISRA
 *  standard). The problem to be solved is the queue size, the a priori
 *  assumption that 1000 is good enough, but a bit magical.
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <math.h>

#if UINT_MAX < 123456789
#error "we need at least 9 decimal digits (32-bit integers)"
#endif


#define MAXSIZE 1000

unsigned queue[MAXSIZE];
unsigned primes[MAXSIZE];

unsigned begin = 0;
unsigned end = 0;
unsigned n = 0;


bool isPrime(unsigned n)
{
    if (n == 2)
    {
        return true;
    }
    if (n == 1 || n % 2 == 0)
    {
        return false;
    }
    unsigned root = sqrt(n);
    for (unsigned k = 3; k <= root; k += 2)
    {
        if (n % k == 0)
        {
            return false;
        }
    }
    return true;
}


int main(int argc, char argv[])
{
    for (int k = 1; k <= 9; k++)
    {
        queue[end++] = k;
    }

    while (begin < end)
    {
        int value = queue[begin++];
        if (isPrime(value))
        {
            primes[n++] = value;
        }
        for (int k = value % 10 + 1; k <= 9; k++)
        {
            queue[end++] = value * 10 + k;
        }
    }

    for (int k = 0; k < n; k++)
    {
        printf("%u ", primes[k]);
    }

    return EXIT_SUCCESS;
}
