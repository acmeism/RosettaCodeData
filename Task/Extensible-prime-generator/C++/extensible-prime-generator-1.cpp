#include <iostream>
#include <cstdint>
#include <queue>
#include <utility>
#include <vector>
#include <limits>

template<typename integer>
class prime_generator {
public:
    integer next_prime();
    integer count() const {
        return count_;
    }
private:
    struct queue_item {
        queue_item(integer prime, integer multiple, unsigned int wheel_index) :
            prime_(prime), multiple_(multiple), wheel_index_(wheel_index) {}
        integer prime_;
        integer multiple_;
        unsigned int wheel_index_;
    };
    struct cmp {
        bool operator()(const queue_item& a, const queue_item& b) const {
            return a.multiple_ > b.multiple_;
        }
    };
    static integer wheel_next(unsigned int& index) {
        integer offset = wheel_[index];
        ++index;
        if (index == std::size(wheel_))
            index = 0;
        return offset;
    }
    typedef std::priority_queue<queue_item, std::vector<queue_item>, cmp> queue;
    integer next_ = 11;
    integer count_ = 0;
    queue queue_;
    unsigned int wheel_index_ = 0;
    static const unsigned int wheel_[];
    static const integer primes_[];
};

template<typename integer>
const unsigned int prime_generator<integer>::wheel_[] = {
    2, 4, 2, 4, 6, 2, 6, 4, 2, 4, 6, 6, 2, 6, 4, 2,
    6, 4, 6, 8, 4, 2, 4, 2, 4, 8, 6, 4, 6, 2, 4, 6,
    2, 6, 6, 4, 2, 4, 6, 2, 6, 4, 2, 4, 2, 10, 2, 10
};

template<typename integer>
const integer prime_generator<integer>::primes_[] = {
    2, 3, 5, 7
};

template<typename integer>
integer prime_generator<integer>::next_prime() {
    if (count_ < std::size(primes_))
        return primes_[count_++];
    integer n = next_;
    integer prev = 0;
    while (!queue_.empty()) {
        queue_item item = queue_.top();
        if (prev != 0 && prev != item.multiple_)
            n += wheel_next(wheel_index_);
        if (item.multiple_ > n)
            break;
        else if (item.multiple_ == n) {
            queue_.pop();
            queue_item new_item(item);
            new_item.multiple_ += new_item.prime_ * wheel_next(new_item.wheel_index_);
            queue_.push(new_item);
        }
        else
            throw std::overflow_error("prime_generator: overflow!");
        prev = item.multiple_;
    }
    if (std::numeric_limits<integer>::max()/n > n)
        queue_.emplace(n, n * n, wheel_index_);
    next_ = n + wheel_next(wheel_index_);
    ++count_;
    return n;
}

int main() {
    typedef uint32_t integer;
    prime_generator<integer> pgen;
    std::cout << "First 20 primes:\n";
    for (int i = 0; i < 20; ++i) {
        integer p = pgen.next_prime();
        if (i != 0)
            std::cout << ", ";
        std::cout << p;
    }
    std::cout << "\nPrimes between 100 and 150:\n";
    for (int n = 0; ; ) {
        integer p = pgen.next_prime();
        if (p > 150)
            break;
        if (p >= 100) {
            if (n != 0)
                std::cout << ", ";
            std::cout << p;
            ++n;
        }
    }
    int count = 0;
    for (;;) {
        integer p = pgen.next_prime();
        if (p > 8000)
            break;
        if (p >= 7700)
            ++count;
    }
    std::cout << "\nNumber of primes between 7700 and 8000: " << count << '\n';

    for (integer n = 10000; n <= 10000000; n *= 10) {
        integer prime;
        while (pgen.count() != n)
            prime = pgen.next_prime();
        std::cout << n << "th prime: " << prime << '\n';
    }
    return 0;
}
