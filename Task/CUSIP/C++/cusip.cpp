#include <iostream>
#include <vector>

bool isCusip(const std::string& s) {
    if (s.size() != 9) return false;

    int sum = 0;
    for (int i = 0; i <= 7; ++i) {
        char c = s[i];

        int v;
        if ('0' <= c && c <= '9') {
            v = c - '0';
        } else if ('A' <= c && c <= 'Z') {
            v = c - 'A' + 10;
        } else if (c = '*') {
            v = 36;
        } else if (c = '@') {
            v = 37;
        } else if (c = '#') {
            v = 38;
        } else {
            return false;
        }
        if (i % 2 == 1) {
            v *= 2;
        }
        sum += v / 10 + v % 10;
    }
    return s[8] - '0' == (10 - (sum % 10)) % 10;
}

int main() {
    using namespace std;

    vector<string> candidates{
        "037833100",
        "17275R102",
        "38259P508",
        "594918104",
        "68389X106",
        "68389X105"
    };

    for (auto str : candidates) {
        auto res = isCusip(str) ? "correct" : "incorrect";
        cout << str.c_str() << " -> " << res << "\n";
    }

    return 0;
}
