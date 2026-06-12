#include <chrono>
#include <cmath>
#include <iomanip>
#include <iostream>
#include <numeric>
#include <vector>

class prime_counter {
public:
    explicit prime_counter(int limit);
    int prime_count(int n) const { return n < 1 ? 0 : count_.at(n); }

private:
    std::vector<int> count_;
};

prime_counter::prime_counter(int limit) : count_(limit, 1) {
    if (limit > 0)
        count_[0] = 0;
    if (limit > 1)
        count_[1] = 0;
    for (int i = 4; i < limit; i += 2)
        count_[i] = 0;
    for (int p = 3, sq = 9; sq < limit; p += 2) {
        if (count_[p]) {
            for (int q = sq; q < limit; q += p << 1)
                count_[q] = 0;
        }
        sq += (p + 1) << 2;
    }
    std::partial_sum(count_.begin(), count_.end(), count_.begin());
}

int ramanujan_max(int n) {
    return static_cast<int>(std::ceil(4 * n * std::log(4 * n)));
}

int ramanujan_prime(const prime_counter& pc, int n) {
    int max = ramanujan_max(n);
    for (int i = max; i >= 0; --i) {
        if (pc.prime_count(i) - pc.prime_count(i / 2) < n)
            return i + 1;
    }
    return 0;
}

int main() {
    std::cout.imbue(std::locale(""));
    auto start = std::chrono::high_resolution_clock::now();
    prime_counter pc(1 + ramanujan_max(100000));
    for (int i = 1; i <= 100; ++i) {
        std::cout << std::setw(5) << ramanujan_prime(pc, i)
                  << (i % 10 == 0 ? '\n' : ' ');
    }
    std::cout << '\n';
    for (int n = 1000; n <= 100000; n *= 10) {
        std::cout << "The " << n << "th Ramanujan prime is " << ramanujan_prime(pc, n)
              << ".\n";
    }
    auto end = std::chrono::high_resolution_clock::now();
    std::cout << "\nElapsed time: "
              << std::chrono::duration<double>(end - start).count() * 1000
              << " milliseconds\n";
}
