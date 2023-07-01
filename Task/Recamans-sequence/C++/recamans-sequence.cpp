#include <iostream>
#include <ostream>
#include <set>
#include <vector>

template<typename T>
std::ostream& operator<<(std::ostream& os, const std::vector<T>& v) {
    auto i = v.cbegin();
    auto e = v.cend();
    os << '[';
    if (i != e) {
        os << *i;
        i = std::next(i);
    }
    while (i != e) {
        os << ", " << *i;
        i = std::next(i);
    }
    return os << ']';
}

int main() {
    using namespace std;

    vector<int> a{ 0 };
    set<int> used{ 0 };
    set<int> used1000{ 0 };
    bool foundDup = false;
    int n = 1;
    while (n <= 15 || !foundDup || used1000.size() < 1001) {
        int next = a[n - 1] - n;
        if (next < 1 || used.find(next) != used.end()) {
            next += 2 * n;
        }
        bool alreadyUsed = used.find(next) != used.end();
        a.push_back(next);
        if (!alreadyUsed) {
            used.insert(next);
            if (0 <= next && next <= 1000) {
                used1000.insert(next);
            }
        }
        if (n == 14) {
            cout << "The first 15 terms of the Recaman sequence are: " << a << '\n';
        }
        if (!foundDup && alreadyUsed) {
            cout << "The first duplicated term is a[" << n << "] = " << next << '\n';
            foundDup = true;
        }
        if (used1000.size() == 1001) {
            cout << "Terms up to a[" << n << "] are needed to generate 0 to 1000\n";
        }
        n++;
    }

    return 0;
}
