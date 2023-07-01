#include <algorithm>
#include <functional>
#include <iostream>
#include <iterator>
#include <string>
#include <sstream>
#include <vector>

typedef unsigned char byte;

std::string deBruijn(int k, int n) {
    std::vector<byte> a(k * n, 0);
    std::vector<byte> seq;

    std::function<void(int, int)> db;
    db = [&](int t, int p) {
        if (t > n) {
            if (n % p == 0) {
                for (int i = 1; i < p + 1; i++) {
                    seq.push_back(a[i]);
                }
            }
        } else {
            a[t] = a[t - p];
            db(t + 1, p);
            auto j = a[t - p] + 1;
            while (j < k) {
                a[t] = j & 0xFF;
                db(t + 1, t);
                j++;
            }
        }
    };

    db(1, 1);
    std::string buf;
    for (auto i : seq) {
        buf.push_back('0' + i);
    }
    return buf + buf.substr(0, n - 1);
}

bool allDigits(std::string s) {
    for (auto c : s) {
        if (c < '0' || '9' < c) {
            return false;
        }
    }
    return true;
}

void validate(std::string db) {
    auto le = db.size();
    std::vector<int> found(10000, 0);
    std::vector<std::string> errs;

    // Check all strings of 4 consecutive digits within 'db'
    // to see if all 10,000 combinations occur without duplication.
    for (size_t i = 0; i < le - 3; i++) {
        auto s = db.substr(i, 4);
        if (allDigits(s)) {
            auto n = stoi(s);
            found[n]++;
        }
    }

    for (int i = 0; i < 10000; i++) {
        if (found[i] == 0) {
            std::stringstream ss;
            ss << "    PIN number " << i << " missing";
            errs.push_back(ss.str());
        } else if (found[i] > 1) {
            std::stringstream ss;
            ss << "    PIN number " << i << " occurs " << found[i] << " times";
            errs.push_back(ss.str());
        }
    }

    if (errs.empty()) {
        std::cout << "  No errors found\n";
    } else {
        auto pl = (errs.size() == 1) ? "" : "s";
        std::cout << "  " << errs.size() << " error" << pl << " found:\n";
        for (auto e : errs) {
            std::cout << e << '\n';
        }
    }
}

int main() {
    std::ostream_iterator<byte> oi(std::cout, "");
    auto db = deBruijn(10, 4);

    std::cout << "The length of the de Bruijn sequence is " << db.size() << "\n\n";
    std::cout << "The first 130 digits of the de Bruijn sequence are: ";
    std::copy_n(db.cbegin(), 130, oi);
    std::cout << "\n\nThe last 130 digits of the de Bruijn sequence are: ";
    std::copy(db.cbegin() + (db.size() - 130), db.cend(), oi);
    std::cout << "\n";

    std::cout << "\nValidating the de Bruijn sequence:\n";
    validate(db);

    std::cout << "\nValidating the reversed de Bruijn sequence:\n";
    auto rdb = db;
    std::reverse(rdb.begin(), rdb.end());
    validate(rdb);

    auto by = db;
    by[4443] = '.';
    std::cout << "\nValidating the overlaid de Bruijn sequence:\n";
    validate(by);

    return 0;
}
