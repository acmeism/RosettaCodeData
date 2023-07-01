#include <iomanip>
#include <iostream>
#include <tuple>
#include <vector>

const std::string DIGITS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

std::string encodeNegativeBase(int64_t n, int b) {
    if (b < -62 || b > -1) {
        throw std::runtime_error("Argument out of range: b");
    }
    if (n == 0) {
        return "0";
    }

    std::string output;
    int64_t nn = n;
    while (nn != 0) {
        int rem = nn % b;
        nn /= b;
        if (rem < 0) {
            nn++;
            rem -= b;
        }
        output += DIGITS[rem];
    }

    std::reverse(output.begin(), output.end());
    return output;
}

int64_t decodeNegativeBase(const std::string& ns, int b) {
    if (b < -62 || b > -1) {
        throw std::runtime_error("Argument out of range: b");
    }
    if (ns == "0") {
        return 0;
    }

    int64_t total = 0;
    int64_t bb = 1;

    for (auto it = ns.crbegin(); it != ns.crend(); it = std::next(it)) {
        auto ptr = std::find(DIGITS.cbegin(), DIGITS.cend(), *it);
        if (ptr != DIGITS.cend()) {
            auto idx = ptr - DIGITS.cbegin();
            total += idx * bb;
        }
        bb *= b;
    }
    return total;
}

int main() {
    using namespace std;

    vector<pair<int64_t, int>> nbl({
        make_pair(10, -2),
        make_pair(146, -3),
        make_pair(15, -10),
        make_pair(142961, -62)
        });

    for (auto& p : nbl) {
        string ns = encodeNegativeBase(p.first, p.second);
        cout << setw(12) << p.first << " encoded in base " << setw(3) << p.second << " = " << ns.c_str() << endl;

        int64_t n = decodeNegativeBase(ns, p.second);
        cout << setw(12) << ns.c_str() << " decoded in base " << setw(3) << p.second << " = " << n << endl;

        cout << endl;
    }

    return 0;
}
