#include <iostream>
#include <algorithm>
#include <vector>

template <typename ForwardIterator>
size_t prime_sieve(ForwardIterator start, ForwardIterator end)
{
    if (start == end) return 0;
    // clear the container with 0
    std::fill(start, end, 0);
    // mark composites with 1
    for (ForwardIterator prime_it = start + 1; prime_it != end; ++prime_it)
    {
        if (*prime_it == 1) continue;
        // determine the prime number represented by this iterator location
        size_t stride = (prime_it - start) + 1;
        // mark all multiples of this prime number up to max
        ForwardIterator mark_it = prime_it;
        while ((end - mark_it) > stride)
        {
            std::advance(mark_it, stride);
            *mark_it = 1;
        }
    }
    // copy marked primes into container
    ForwardIterator out_it = start;
    for (ForwardIterator it = start + 1; it != end; ++it)
    {
        if (*it == 0)
        {
            *out_it = (it - start) + 1;
            ++out_it;
        }
    }
    return out_it - start;
}

int main(int argc, const char* argv[])
{
    std::vector<int> primes(100);
    size_t count = prime_sieve(primes.begin(), primes.end());
    // display the primes
    for (size_t i = 0; i < count; ++i)
        std::cout << primes[i] << " ";
    std::cout << std::endl;
    return 1;
}
