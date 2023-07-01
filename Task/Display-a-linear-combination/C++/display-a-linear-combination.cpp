#include <iomanip>
#include <iostream>
#include <sstream>
#include <vector>

template<typename T>
std::ostream& operator<<(std::ostream& os, const std::vector<T>& v) {
    auto it = v.cbegin();
    auto end = v.cend();

    os << '[';
    if (it != end) {
        os << *it;
        it = std::next(it);
    }
    while (it != end) {
        os << ", " << *it;
        it = std::next(it);
    }
    return os << ']';
}

std::ostream& operator<<(std::ostream& os, const std::string& s) {
    return os << s.c_str();
}

std::string linearCombo(const std::vector<int>& c) {
    std::stringstream ss;
    for (size_t i = 0; i < c.size(); i++) {
        int n = c[i];
        if (n < 0) {
            if (ss.tellp() == 0) {
                ss << '-';
            } else {
                ss << " - ";
            }
        } else if (n > 0) {
            if (ss.tellp() != 0) {
                ss << " + ";
            }
        } else {
            continue;
        }

        int av = abs(n);
        if (av != 1) {
            ss << av << '*';
        }
        ss << "e(" << i + 1 << ')';
    }
    if (ss.tellp() == 0) {
        return "0";
    }
    return ss.str();
}

int main() {
    using namespace std;

    vector<vector<int>> combos{
        {1, 2, 3},
        {0, 1, 2, 3},
        {1, 0, 3, 4},
        {1, 2, 0},
        {0, 0, 0},
        {0},
        {1, 1, 1},
        {-1, -1, -1},
        {-1, -2, 0, -3},
        {-1},
    };

    for (auto& c : combos) {
        stringstream ss;
        ss << c;
        cout << setw(15) << ss.str() << " -> ";
        cout << linearCombo(c) << '\n';
    }

    return 0;
}
