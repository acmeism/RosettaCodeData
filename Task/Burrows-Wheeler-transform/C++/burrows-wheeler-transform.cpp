#include <algorithm>
#include <iostream>
#include <vector>

const int STX = 0x02;
const int ETX = 0x03;

void rotate(std::string &a) {
    char t = a[a.length() - 1];
    for (int i = a.length() - 1; i > 0; i--) {
        a[i] = a[i - 1];
    }
    a[0] = t;
}

std::string bwt(const std::string &s) {
    for (char c : s) {
        if (c == STX || c == ETX) {
            throw std::runtime_error("Input can't contain STX or ETX");
        }
    }

    std::string ss;
    ss += STX;
    ss += s;
    ss += ETX;

    std::vector<std::string> table;
    for (size_t i = 0; i < ss.length(); i++) {
        table.push_back(ss);
        rotate(ss);
    }
    //table.sort();
    std::sort(table.begin(), table.end());

    std::string out;
    for (auto &s : table) {
        out += s[s.length() - 1];
    }
    return out;
}

std::string ibwt(const std::string &r) {
    int len = r.length();
    std::vector<std::string> table(len);
    for (int i = 0; i < len; i++) {
        for (int j = 0; j < len; j++) {
            table[j] = r[j] + table[j];
        }
        std::sort(table.begin(), table.end());
    }
    for (auto &row : table) {
        if (row[row.length() - 1] == ETX) {
            return row.substr(1, row.length() - 2);
        }
    }
    return {};
}

std::string makePrintable(const std::string &s) {
    auto ls = s;
    for (auto &c : ls) {
        if (c == STX) {
            c = '^';
        } else if (c == ETX) {
            c = '|';
        }
    }
    return ls;
}

int main() {
    auto tests = {
        "banana",
        "appellee",
        "dogwood",
        "TO BE OR NOT TO BE OR WANT TO BE OR NOT?",
        "SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES",
        "\u0002ABC\u0003"
    };

    for (auto &test : tests) {
        std::cout << makePrintable(test) << "\n";
        std::cout << " --> ";

        std::string t;
        try {
            t = bwt(test);
            std::cout << makePrintable(t) << "\n";
        } catch (std::runtime_error &e) {
            std::cout << "Error " << e.what() << "\n";
        }

        std::string r = ibwt(t);
        std::cout << " --> " << r << "\n\n";
    }

    return 0;
}
