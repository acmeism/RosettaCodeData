#include <iostream>

struct fraction {
    fraction(int n, int d) : numerator(n), denominator(d) {}
    int numerator;
    int denominator;
};

std::ostream& operator<<(std::ostream& out, const fraction& f) {
    out << f.numerator << '/' << f.denominator;
    return out;
}

class farey_sequence {
public:
    explicit farey_sequence(int n) : n_(n), a_(0), b_(1), c_(1), d_(n) {}
    fraction next() {
        // See https://en.wikipedia.org/wiki/Farey_sequence#Next_term
        fraction result(a_, b_);
        int k = (n_ + b_)/d_;
        int next_c = k * c_ - a_;
        int next_d = k * d_ - b_;
        a_ = c_;
        b_ = d_;
        c_ = next_c;
        d_ = next_d;
        return result;
    }
    bool has_next() const { return a_ <= n_; }
private:
    int n_, a_, b_, c_, d_;
};

int main() {
    for (int n = 1; n <= 11; ++n) {
        farey_sequence seq(n);
        std::cout << n << ": " << seq.next();
        while (seq.has_next())
            std::cout << ' ' << seq.next();
        std::cout << '\n';
    }
    for (int n = 100; n <= 1000; n += 100) {
        int count = 0;
        for (farey_sequence seq(n); seq.has_next(); seq.next())
            ++count;
        std::cout << n << ": " << count << '\n';
    }
    return 0;
}
