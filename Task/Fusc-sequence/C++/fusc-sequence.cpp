#include <iomanip>
#include <iostream>
#include <limits>
#include <sstream>
#include <vector>

const int n = 61;
std::vector<int> l{ 0, 1 };

int fusc(int n) {
    if (n < l.size()) return l[n];
    int f = (n & 1) == 0 ? l[n >> 1] : l[(n - 1) >> 1] + l[(n + 1) >> 1];
    l.push_back(f);
    return f;
}

int main() {
    bool lst = true;
    int w = -1;
    int c = 0;
    int t;
    std::string res;
    std::cout << "First " << n << " numbers in the fusc sequence:\n";
    for (int i = 0; i < INT32_MAX; i++) {
        int f = fusc(i);
        if (lst) {
            if (i < 61) {
                std::cout << f << ' ';
            } else {
                lst = false;
                std::cout << "\nPoints in the sequence where an item has more digits than any previous items:\n";
                std::cout << std::setw(11) << "Index\\" << "  " << std::left << std::setw(9) << "/Value\n";
                std::cout << res << '\n';
                res = "";
            }
        }
        std::stringstream ss;
        ss << f;
        t = ss.str().length();
        ss.str("");
        ss.clear();
        if (t > w) {
            w = t;
            res += (res == "" ? "" : "\n");
            ss << std::setw(11) << i << "  " << std::left << std::setw(9) << f;
            res += ss.str();
            if (!lst) {
                std::cout << res << '\n';
                res = "";
            }
            if (++c > 5) {
                break;
            }
        }
    }
    return 0;
}
