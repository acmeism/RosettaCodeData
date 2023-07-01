#include <algorithm>
#include <chrono>
#include <iostream>
#include <numeric>
#include <vector>
#include <boost/iterator/counting_iterator.hpp>

using ulli = unsigned long long int;

// bad style do-while and wrong for Factorial1(0LL) -> 0 !!!
ulli Factorial1(ulli m_nValue) {
    ulli result = m_nValue;
    ulli result_next;
    ulli pc = m_nValue;
    do {
        result_next = result * (pc - 1);
        result = result_next;
        pc--;
    } while (pc > 2);
    return result;
}

// iteration with while
ulli Factorial2(ulli n) {
    ulli r = 1;
    while (1 < n)
        r *= n--;
    return r;
}

// recursive
ulli Factorial3(ulli n) {
    return n < 2 ? 1 : n * Factorial3(n - 1);
}

// tail recursive
inline ulli _fac_aux(ulli n, ulli acc) {
    return n < 1 ? acc : _fac_aux(n - 1, acc * n);
}
ulli Factorial4(ulli n) {
    return _fac_aux(n, 1);
}

// accumulate with functor
ulli Factorial5(ulli n) {
    // last is one-past-end
    return std::accumulate(boost::counting_iterator<ulli>(1ULL),
                           boost::counting_iterator<ulli>(n + 1ULL), 1ULL,
                           std::multiplies<ulli>());
}

// accumulate with lambda
ulli Factorial6(ulli n) {
    // last is one-past-end
    return std::accumulate(boost::counting_iterator<ulli>(1ULL),
                           boost::counting_iterator<ulli>(n + 1ULL), 1ULL,
                           [](ulli a, ulli b) { return a * b; });
}

int main() {
    ulli v = 20; // max value with unsigned long long int
    ulli result;
    std::cout << std::fixed;
    using duration = std::chrono::duration<double, std::micro>;

    {
        auto t1 = std::chrono::high_resolution_clock::now();
        result = Factorial1(v);
        auto t2 = std::chrono::high_resolution_clock::now();
        std::cout << "do-while(1)               result " << result << " took " << duration(t2 - t1).count() << " µs\n";
    }

    {
        auto t1 = std::chrono::high_resolution_clock::now();
        result = Factorial2(v);
        auto t2 = std::chrono::high_resolution_clock::now();
        std::cout << "while(2)                  result " << result << " took " << duration(t2 - t1).count() << " µs\n";
    }

    {
        auto t1 = std::chrono::high_resolution_clock::now();
        result = Factorial3(v);
        auto t2 = std::chrono::high_resolution_clock::now();
        std::cout << "recursive(3)              result " << result << " took " << duration(t2 - t1).count() << " µs\n";
    }

    {
        auto t1 = std::chrono::high_resolution_clock::now();
        result = Factorial3(v);
        auto t2 = std::chrono::high_resolution_clock::now();
        std::cout << "tail recursive(4)         result " << result << " took " << duration(t2 - t1).count() << " µs\n";
    }

    {
        auto t1 = std::chrono::high_resolution_clock::now();
        result = Factorial5(v);
        auto t2 = std::chrono::high_resolution_clock::now();
        std::cout << "std::accumulate(5)        result " << result << " took " << duration(t2 - t1).count() << " µs\n";
    }

    {
        auto t1 = std::chrono::high_resolution_clock::now();
        result = Factorial6(v);
        auto t2 = std::chrono::high_resolution_clock::now();
        std::cout << "std::accumulate lambda(6) result " << result << " took " << duration(t2 - t1).count() << " µs\n";
    }
}
