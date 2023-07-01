#include <algorithm>
#include <iostream>
#include <numeric>
#include <sstream>
#include <vector>

std::vector<int> divisors(int n) {
    std::vector<int> divs{ 1 };
    std::vector<int> divs2;

    for (int i = 2; i*i <= n; i++) {
        if (n%i == 0) {
            int j = n / i;
            divs.push_back(i);
            if (i != j) {
                divs2.push_back(j);
            }
        }
    }
    std::copy(divs2.crbegin(), divs2.crend(), std::back_inserter(divs));

    return divs;
}

int sum(const std::vector<int>& divs) {
    return std::accumulate(divs.cbegin(), divs.cend(), 0);
}

std::string sumStr(const std::vector<int>& divs) {
    auto it = divs.cbegin();
    auto end = divs.cend();
    std::stringstream ss;

    if (it != end) {
        ss << *it;
        it = std::next(it);
    }
    while (it != end) {
        ss << " + " << *it;
        it = std::next(it);
    }

    return ss.str();
}

int abundantOdd(int searchFrom, int countFrom, int countTo, bool printOne) {
    int count = countFrom;
    int n = searchFrom;
    for (; count < countTo; n += 2) {
        auto divs = divisors(n);
        int tot = sum(divs);
        if (tot > n) {
            count++;
            if (printOne && count < countTo) {
                continue;
            }
            auto s = sumStr(divs);
            if (printOne) {
                printf("%d < %s = %d\n", n, s.c_str(), tot);
            } else {
                printf("%2d. %5d < %s = %d\n", count, n, s.c_str(), tot);
            }
        }
    }
    return n;
}

int main() {
    using namespace std;

    const int max = 25;
    cout << "The first " << max << " abundant odd numbers are:\n";
    int n = abundantOdd(1, 0, 25, false);

    cout << "\nThe one thousandth abundant odd number is:\n";
    abundantOdd(n, 25, 1000, true);

    cout << "\nThe first abundant odd number above one billion is:\n";
    abundantOdd(1e9 + 1, 0, 1, true);

    return 0;
}
