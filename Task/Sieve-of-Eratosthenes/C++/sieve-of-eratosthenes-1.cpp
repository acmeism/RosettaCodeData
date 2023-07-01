#include <iostream>
#include <iterator>
#include <algorithm>
#include <vector>

// Fills the range [start, end) with 1 if the integer corresponding to the index is composite and 0 otherwise.
// requires: I is RandomAccessIterator
template<typename I>
void mark_composites(I start, I end)
{
    std::fill(start, end, 0);

    for (auto it = start + 1; it != end; ++it)
    {
        if (*it == 0)
        {
            auto prime = std::distance(start, it) + 1;
            // mark all multiples of this prime number as composite.
            auto multiple_it = it;
            while (std::distance(multiple_it, end) > prime)
            {
                std::advance(multiple_it, prime);
                *multiple_it = 1;
            }
        }
    }
}

// Fills "out" with the prime numbers in the range 2...N where N = distance(start, end).
// requires: I is a RandomAccessIterator
//           O is an OutputIterator
template <typename I, typename O>
O sieve_primes(I start, I end, O out)
{
    mark_composites(start, end);
    for (auto it = start + 1; it != end; ++it)
    {
        if (*it == 0)
        {
            *out = std::distance(start, it) + 1;
            ++out;
        }
    }
    return out;
}

int main()
{
    std::vector<uint8_t> is_composite(1000);
    sieve_primes(is_composite.begin(), is_composite.end(), std::ostream_iterator<int>(std::cout, " "));

    // Alternative to store in a vector:
    // std::vector<int> primes;
    // sieve_primes(is_composite.begin(), is_composite.end(), std::back_inserter(primes));
}
