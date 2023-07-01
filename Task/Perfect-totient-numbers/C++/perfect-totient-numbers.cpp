#include <cassert>
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

bool perfect_totient_number(const totient_calculator& tc, int n) {
    int sum = 0;
    for (int m = n; m > 1; ) {
        int t = tc.totient(m);
        sum += t;
        m = t;
    }
    return sum == n;
}

int main() {
    totient_calculator tc(10000);
    int count = 0, n = 1;
    std::cout << "First 20 perfect totient numbers:\n";
    for (; count < 20; ++n) {
        if (perfect_totient_number(tc, n))  {
            if (count > 0)
                std::cout << ' ';
            ++count;
            std::cout << n;
        }
    }
    std::cout << '\n';
    return 0;
}
