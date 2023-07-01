#include <cassert>
#include <algorithm>
#include <iomanip>
#include <iostream>
#include <vector>
#include <gmpxx.h>

using big_int = mpz_class;

bool is_prime(const big_int& n) {
    return mpz_probab_prime_p(n.get_mpz_t(), 25);
}

template <typename integer>
class n_smooth_generator {
public:
    explicit n_smooth_generator(size_t n);
    integer next();
    size_t size() const {
        return results_.size();
    }
private:
    std::vector<size_t> primes_;
    std::vector<size_t> index_;
    std::vector<integer> results_;
    std::vector<integer> queue_;
};

template <typename integer>
n_smooth_generator<integer>::n_smooth_generator(size_t n) {
    for (size_t p = 2; p <= n; ++p) {
        if (is_prime(p)) {
            primes_.push_back(p);
            queue_.push_back(p);
        }
    }
    index_.assign(primes_.size(), 0);
    results_.push_back(1);
}

template <typename integer>
integer n_smooth_generator<integer>::next() {
    integer last = results_.back();
    for (size_t i = 0, n = primes_.size(); i < n; ++i) {
        if (queue_[i] == last)
            queue_[i] = results_[++index_[i]] * primes_[i];
    }
    results_.push_back(*min_element(queue_.begin(), queue_.end()));
    return last;
}

void print_vector(const std::vector<big_int>& numbers) {
    for (size_t i = 0, n = numbers.size(); i < n; ++i) {
        std::cout << std::setw(9) << numbers[i];
        if ((i + 1) % 10 == 0)
            std::cout << '\n';
    }
    std::cout << '\n';
}

int main() {
    const int max = 250;
    std::vector<big_int> first, second;
    int count1 = 0;
    int count2 = 0;
    n_smooth_generator<big_int> smooth_gen(3);
    big_int p1, p2;

    while (count1 < max || count2 < max) {
        big_int n = smooth_gen.next();
        if (count1 < max && is_prime(n + 1)) {
            p1 = n + 1;
            if (first.size() < 50)
                first.push_back(p1);
            ++count1;
        }
        if (count2 < max && is_prime(n - 1)) {
            p2 = n - 1;
            if (second.size() < 50)
                second.push_back(p2);
            ++count2;
        }
    }

    std::cout << "First 50 Pierpont primes of the first kind:\n";
    print_vector(first);
    std::cout << "First 50 Pierpont primes of the second kind:\n";
    print_vector(second);

    std::cout << "250th Pierpont prime of the first kind: " << p1 << '\n';
    std::cout << "250th Pierpont prime of the second kind: " << p2 << '\n';
    return 0;
}
