#include <iostream>
#include <vector>

int main()
{
    const int limit = 1000000;

    // find the prime numbers up to the limit
    std::vector<bool> isprime(limit + 1, true);
    isprime[0] = isprime[1] = false;
    for (int p = 2; p * p <= limit; ++p)
    {
        if (isprime[p])
        {
            for (int i = p * p; i <= limit; i += p)
                isprime[i] = false;
        }
    }
    int largest_left = 0;
    int largest_right = 0;
    // find largest left truncatable prime
    for (int p = limit; p >= 2; --p)
    {
        if (!isprime[p])
            continue;
        bool left_truncatable = true;
        for (int n = 10, q = p; p > n; n *= 10)
        {
            if (!isprime[p % n] || q == p % n)
            {
                left_truncatable = false;
                break;
            }
            q = p % n;
        }
        if (left_truncatable)
        {
            largest_left = p;
            break;
        }
    }
    // find largest right truncatable prime
    for (int p = limit; p >= 2; --p)
    {
        if (!isprime[p])
            continue;
        bool right_truncatable = true;
        for (int q = p/10; q > 0; q /= 10)
        {
            if (!isprime[q])
            {
                right_truncatable = false;
                break;
            }
        }
        if (right_truncatable)
        {
            largest_right = p;
            break;
        }
    }
    // write results to standard output
    std::cout << "Largest left truncatable prime is " << largest_left << '\n';
    std::cout << "Largest right truncatable prime is " << largest_right << '\n';
    return 0;
}
