#include <iostream>
#include <sstream>
#include <set>

bool checkDec(int num) {
    std::set<int> set;

    std::stringstream ss;
    ss << num;
    auto str = ss.str();

    for (int i = 0; i < str.size(); ++i) {
        char c = str[i];
        int d = c - '0';
        if (d == 0) return false;
        if (num % d != 0) return false;
        if (set.find(d) != set.end()) {
            return false;
        }
        set.insert(d);
    }

    return true;
}

int main() {
    for (int i = 98764321; i > 0; i--) {
        if (checkDec(i)) {
            std::cout << i << "\n";
            break;
        }
    }

    return 0;
}
