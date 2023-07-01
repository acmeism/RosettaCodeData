#include <iostream>
#include <numeric>
#include <set>

template <typename integer>
class yellowstone_generator {
public:
    integer next() {
        n2_ = n1_;
        n1_ = n_;
        if (n_ < 3) {
            ++n_;
        } else {
            for (n_ = min_; !(sequence_.count(n_) == 0
                && std::gcd(n1_, n_) == 1
                && std::gcd(n2_, n_) > 1); ++n_) {}
        }
        sequence_.insert(n_);
        for (;;) {
            auto it = sequence_.find(min_);
            if (it == sequence_.end())
                break;
            sequence_.erase(it);
            ++min_;
        }
        return n_;
    }
private:
    std::set<integer> sequence_;
    integer min_ = 1;
    integer n_ = 0;
    integer n1_ = 0;
    integer n2_ = 0;
};

int main() {
    std::cout << "First 30 Yellowstone numbers:\n";
    yellowstone_generator<unsigned int> ygen;
    std::cout << ygen.next();
    for (int i = 1; i < 30; ++i)
        std::cout << ' ' << ygen.next();
    std::cout << '\n';
    return 0;
}
