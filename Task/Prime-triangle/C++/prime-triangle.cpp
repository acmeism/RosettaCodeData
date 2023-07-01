#include <cassert>
#include <chrono>
#include <iomanip>
#include <iostream>
#include <numeric>
#include <vector>

bool is_prime(unsigned int n) {
    assert(n > 0 && n < 64);
    return (1ULL << n) & 0x28208a20a08a28ac;
}

template <typename Iterator>
bool prime_triangle_row(Iterator begin, Iterator end) {
    if (std::distance(begin, end) == 2)
        return is_prime(*begin + *(begin + 1));
    for (auto i = begin + 1; i + 1 != end; ++i) {
        if (is_prime(*begin + *i)) {
            std::iter_swap(i, begin + 1);
            if (prime_triangle_row(begin + 1, end))
                return true;
            std::iter_swap(i, begin + 1);
        }
    }
    return false;
}

template <typename Iterator>
void prime_triangle_count(Iterator begin, Iterator end, int& count) {
    if (std::distance(begin, end) == 2) {
        if (is_prime(*begin + *(begin + 1)))
            ++count;
        return;
    }
    for (auto i = begin + 1; i + 1 != end; ++i) {
        if (is_prime(*begin + *i)) {
            std::iter_swap(i, begin + 1);
            prime_triangle_count(begin + 1, end, count);
            std::iter_swap(i, begin + 1);
        }
    }
}

template <typename Iterator>
void print(Iterator begin, Iterator end) {
    if (begin == end)
        return;
    auto i = begin;
    std::cout << std::setw(2) << *i++;
    for (; i != end; ++i)
        std::cout << ' ' << std::setw(2) << *i;
    std::cout << '\n';
}

int main() {
    auto start = std::chrono::high_resolution_clock::now();
    for (unsigned int n = 2; n < 21; ++n) {
        std::vector<unsigned int> v(n);
        std::iota(v.begin(), v.end(), 1);
        if (prime_triangle_row(v.begin(), v.end()))
            print(v.begin(), v.end());
    }
    std::cout << '\n';
    for (unsigned int n = 2; n < 21; ++n) {
        std::vector<unsigned int> v(n);
        std::iota(v.begin(), v.end(), 1);
        int count = 0;
        prime_triangle_count(v.begin(), v.end(), count);
        if (n > 2)
            std::cout << ' ';
        std::cout << count;
    }
    std::cout << '\n';
    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> duration(end - start);
    std::cout << "\nElapsed time: " << duration.count() << " seconds\n";
}
