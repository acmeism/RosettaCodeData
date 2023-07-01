#include <iostream>
#include <gmpxx.h>

template <typename integer>
class left_factorial_generator {
public:
    integer next() {
        integer result = next_;
        next_ += factorial_;
        factorial_ *= n_++;
        return result;
    }
private:
    unsigned int n_ = 1;
    integer factorial_ = 1;
    integer next_ = 0;
};

int main() {
    left_factorial_generator<mpz_class> lf;
    int i = 0;
    std::cout << "Left factorials 0 through 10:\n";
    for (; i <= 10; ++i)
        std::cout << "!" << i << " = " << lf.next() << '\n';
    std::cout << "Left factorials 20 through 110, by tens:\n";
    for (; i <= 110; ++i) {
        auto n = lf.next();
        if (i % 10 == 0)
            std::cout << "!" << i << " = " << n << '\n';
    }
    std::cout << "Lengths of left factorials 1000 through 10000, by thousands:\n";
    for (; i <= 10000; ++i) {
        auto n = lf.next();
        if (i % 1000 == 0)
           std::cout << "length of !" << i << " = " << n.get_str().size() << '\n';
    }
    return 0;
}
