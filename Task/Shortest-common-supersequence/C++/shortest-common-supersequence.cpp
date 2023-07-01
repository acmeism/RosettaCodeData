#include <iostream>

std::string scs(std::string x, std::string y) {
    if (x.empty()) {
        return y;
    }
    if (y.empty()) {
        return x;
    }
    if (x[0] == y[0]) {
        return x[0] + scs(x.substr(1), y.substr(1));
    }
    if (scs(x, y.substr(1)).size() <= scs(x.substr(1), y).size()) {
        return y[0] + scs(x, y.substr(1));
    } else {
        return x[0] + scs(x.substr(1), y);
    }
}

int main() {
    auto res = scs("abcbdab", "bdcaba");
    std::cout << res << '\n';
    return 0;
}
