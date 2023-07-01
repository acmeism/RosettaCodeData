#include <algorithm>
#include <iostream>
#include <numeric>
#include <vector>

std::vector<int> divisors(int n) {
    std::vector<int> divs = { 1 };
    std::vector<int> divs2;

    for (int i = 2; i * i <= n; i++) {
        if (n % i == 0) {
            int j = n / i;
            divs.push_back(i);
            if (i != j) {
                divs2.push_back(j);
            }
        }
    }

    std::copy(divs.cbegin(), divs.cend(), std::back_inserter(divs2));
    return divs2;
}

bool abundant(int n, const std::vector<int> &divs) {
    return std::accumulate(divs.cbegin(), divs.cend(), 0) > n;
}

template<typename IT>
bool semiperfect(int n, const IT &it, const IT &end) {
    if (it != end) {
        auto h = *it;
        auto t = std::next(it);
        if (n < h) {
            return semiperfect(n, t, end);
        } else {
            return n == h
                || semiperfect(n - h, t, end)
                || semiperfect(n, t, end);
        }
    } else {
        return false;
    }
}

template<typename C>
bool semiperfect(int n, const C &c) {
    return semiperfect(n, std::cbegin(c), std::cend(c));
}

std::vector<bool> sieve(int limit) {
    // false denotes abundant and not semi-perfect.
    // Only interested in even numbers >= 2
    std::vector<bool> w(limit);
    for (int i = 2; i < limit; i += 2) {
        if (w[i]) continue;
        auto divs = divisors(i);
        if (!abundant(i, divs)) {
            w[i] = true;
        } else if (semiperfect(i, divs)) {
            for (int j = i; j < limit; j += i) {
                w[j] = true;
            }
        }
    }
    return w;
}

int main() {
    auto w = sieve(17000);
    int count = 0;
    int max = 25;
    std::cout << "The first 25 weird numbers:";
    for (int n = 2; count < max; n += 2) {
        if (!w[n]) {
            std::cout << n << ' ';
            count++;
        }
    }
    std::cout << '\n';
    return 0;
}
