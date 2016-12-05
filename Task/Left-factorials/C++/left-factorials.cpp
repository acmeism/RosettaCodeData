#include <vector>
#include <string>
#include <algorithm>
#include <iostream>
#include <sstream>
using namespace std;

#if 1 // optimized for 64-bit architecture
typedef unsigned long usingle;
typedef unsigned long long udouble;
const int word_len = 32;
#else // optimized for 32-bit architecture
typedef unsigned short usingle;
typedef unsigned long udouble;
const int word_len = 16;
#endif

class bignum {
private:
    // rep_.size() == 0 if and only if the value is zero.
    // Otherwise, the word rep_[0] keeps the least significant bits.
    vector<usingle> rep_;
public:
    explicit bignum(usingle n = 0) { if (n > 0) rep_.push_back(n); }
    bool equals(usingle n) const {
        if (n == 0) return rep_.empty();
        if (rep_.size() > 1) return false;
        return rep_[0] == n;
    }
    bignum add(usingle addend) const {
        bignum result(0);
        udouble sum = addend;
        for (size_t i = 0; i < rep_.size(); ++i) {
            sum += rep_[i];
            result.rep_.push_back(sum & (((udouble)1 << word_len) - 1));
            sum >>= word_len;
        }
        if (sum > 0) result.rep_.push_back((usingle)sum);
        return result;
    }
    bignum add(const bignum& addend) const {
        bignum result(0);
        udouble sum = 0;
        size_t sz1 = rep_.size();
        size_t sz2 = addend.rep_.size();
        for (size_t i = 0; i < max(sz1, sz2); ++i) {
            if (i < sz1) sum += rep_[i];
            if (i < sz2) sum += addend.rep_[i];
            result.rep_.push_back(sum & (((udouble)1 << word_len) - 1));
            sum >>= word_len;
        }
        if (sum > 0) result.rep_.push_back((usingle)sum);
        return result;
    }
    bignum multiply(usingle factor) const {
        bignum result(0);
        udouble product = 0;
        for (size_t i = 0; i < rep_.size(); ++i) {
            product += (udouble)rep_[i] * factor;
            result.rep_.push_back(product & (((udouble)1 << word_len) - 1));
            product >>= word_len;
        }
        if (product > 0)
            result.rep_.push_back((usingle)product);
        return result;
    }
    void divide(usingle divisor, bignum& quotient, usingle& remainder) const {
        quotient.rep_.resize(0);
        udouble dividend = 0;
        remainder = 0;
        for (size_t i = rep_.size(); i > 0; --i) {
            dividend = ((udouble)remainder << word_len) + rep_[i - 1];
            usingle quo = (usingle)(dividend / divisor);
            remainder = (usingle)(dividend % divisor);
            if (quo > 0 || i < rep_.size())
                quotient.rep_.push_back(quo);
        }
        reverse(quotient.rep_.begin(), quotient.rep_.end());
    }
};

ostream& operator<<(ostream& os, const bignum& x);

ostream& operator<<(ostream& os, const bignum& x) {
    string rep;
    bignum dividend = x;
    bignum quotient;
    usingle remainder;
    while (true) {
        dividend.divide(10, quotient, remainder);
        rep += (char)('0' + remainder);
        if (quotient.equals(0)) break;
        dividend = quotient;
    }
    reverse(rep.begin(), rep.end());
    os << rep;
    return os;
}

bignum lfact(usingle n);

bignum lfact(usingle n) {
    bignum result(0);
    bignum f(1);
    for (usingle k = 1; k <= n; ++k) {
        result = result.add(f);
        f = f.multiply(k);
    }
    return result;
}

int main() {
    for (usingle i = 0; i <= 10; ++i) {
        cout << "!" << i << " = " << lfact(i) << endl;
    }

    for (usingle i = 20; i <= 110; i += 10) {
        cout << "!" << i << " = " << lfact(i) << endl;
    }

    for (usingle i = 1000; i <= 10000; i += 1000) {
        stringstream ss;
        ss << lfact(i);
        cout << "!" << i << " has " << ss.str().size()
            << " digits." << endl;
    }
}
