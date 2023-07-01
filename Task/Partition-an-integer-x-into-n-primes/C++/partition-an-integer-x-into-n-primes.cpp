#include <algorithm>
#include <functional>
#include <iostream>
#include <vector>

std::vector<int> primes;

struct Seq {
public:
    bool empty() {
        return p < 0;
    }

    int front() {
        return p;
    }

    void popFront() {
        if (p == 2) {
            p++;
        } else {
            p += 2;
            while (!empty() && !isPrime(p)) {
                p += 2;
            }
        }
    }

private:
    int p = 2;

    bool isPrime(int n) {
        if (n < 2) return false;
        if (n % 2 == 0) return n == 2;
        if (n % 3 == 0) return n == 3;

        int d = 5;
        while (d * d <= n) {
            if (n % d == 0) return false;
            d += 2;
            if (n % d == 0) return false;
            d += 4;
        }
        return true;
    }
};

// generate the first 50,000 primes and call it good
void init() {
    Seq seq;

    while (!seq.empty() && primes.size() < 50000) {
        primes.push_back(seq.front());
        seq.popFront();
    }
}

bool findCombo(int k, int x, int m, int n, std::vector<int>& combo) {
    if (k >= m) {
        int sum = 0;
        for (int idx : combo) {
            sum += primes[idx];
        }

        if (sum == x) {
            auto word = (m > 1) ? "primes" : "prime";
            printf("Partitioned %5d with %2d %s ", x, m, word);
            for (int idx = 0; idx < m; ++idx) {
                std::cout << primes[combo[idx]];
                if (idx < m - 1) {
                    std::cout << '+';
                } else {
                    std::cout << '\n';
                }
            }
            return true;
        }
    } else {
        for (int j = 0; j < n; j++) {
            if (k == 0 || j > combo[k - 1]) {
                combo[k] = j;
                bool foundCombo = findCombo(k + 1, x, m, n, combo);
                if (foundCombo) {
                    return true;
                }
            }
        }
    }

    return false;
}

void partition(int x, int m) {
    if (x < 2 || m < 1 || m >= x) {
        throw std::runtime_error("Invalid parameters");
    }

    std::vector<int> filteredPrimes;
    std::copy_if(
        primes.cbegin(), primes.cend(),
        std::back_inserter(filteredPrimes),
        [x](int a) { return a <= x; }
    );

    int n = filteredPrimes.size();
    if (n < m) {
        throw std::runtime_error("Not enough primes");
    }

    std::vector<int> combo;
    combo.resize(m);
    if (!findCombo(0, x, m, n, combo)) {
        auto word = (m > 1) ? "primes" : "prime";
        printf("Partitioned %5d with %2d %s: (not possible)\n", x, m, word);
    }
}

int main() {
    init();

    std::vector<std::pair<int, int>> a{
        {99809,  1},
        {   18,  2},
        {   19,  3},
        {   20,  4},
        { 2017, 24},
        {22699,  1},
        {22699,  2},
        {22699,  3},
        {22699,  4},
        {40355,  3}
    };

    for (auto& p : a) {
        partition(p.first, p.second);
    }

    return 0;
}
