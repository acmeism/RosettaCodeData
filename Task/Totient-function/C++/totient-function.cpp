#include <cassert>
#include <iomanip>
#include <iostream>
#include <vector>

class totient_calculator {
public:
    explicit totient_calculator(int max) : totient_(max + 1) {
        for (int i = 1; i <= max; ++i)
            totient_[i] = i;
        for (int i = 2; i <= max; ++i) {
            if (totient_[i] < i)
                continue;
            for (int j = i; j <= max; j += i)
                totient_[j] -= totient_[j] / i;
        }
    }
    int totient(int n) const {
        assert (n >= 1 && n < totient_.size());
        return totient_[n];
    }
    bool is_prime(int n) const {
        return totient(n) == n - 1;
    }
private:
    std::vector<int> totient_;
};

int count_primes(const totient_calculator& tc, int min, int max) {
    int count = 0;
    for (int i = min; i <= max; ++i) {
        if (tc.is_prime(i))
            ++count;
    }
    return count;
}

int main() {
    const int max = 10000000;
    totient_calculator tc(max);
    std::cout << " n  totient  prime?\n";
    for (int i = 1; i <= 25; ++i) {
        std::cout << std::setw(2) << i
            << std::setw(9) << tc.totient(i)
            << std::setw(8) << (tc.is_prime(i) ? "yes" : "no") << '\n';
    }
    for (int n = 100; n <= max; n *= 10) {
        std::cout << "Count of primes up to " << n << ": "
            << count_primes(tc, 1, n) << '\n';
    }
    return 0;
}
