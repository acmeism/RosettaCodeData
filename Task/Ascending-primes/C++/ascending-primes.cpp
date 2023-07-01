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

#include <cmath>
#include <iostream>
#include <queue>
#include <vector>

using namespace std;


queue<unsigned> suspected;
vector<unsigned> primes;


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
    for (unsigned k = 1; k <= 9; k++)
    {
        suspected.push(k);
    }

    while (!suspected.empty())
    {
        int n = suspected.front();
        suspected.pop();

        if (isPrime(n))
        {
            primes.push_back(n);
        }

        //  The value of n % 10 gives the least significient digit of n
        //
        for (unsigned k = n % 10 + 1; k <= 9; k++)
        {
            suspected.push(n * 10 + k);
        }
    }

    copy(primes.begin(), primes.end(), ostream_iterator<unsigned>(cout, " "));

    return EXIT_SUCCESS;
}
