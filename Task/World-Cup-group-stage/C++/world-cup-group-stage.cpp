#include <algorithm>
#include <array>
#include <iomanip>
#include <iostream>
#include <sstream>

std::array<std::string, 6> games{ "12", "13", "14", "23", "24", "34" };
std::string results = "000000";

int fromBase3(std::string num) {
    int out = 0;
    for (auto c : num) {
        int d = c - '0';
        out = 3 * out + d;
    }
    return out;
}

std::string toBase3(int num) {
    std::stringstream ss;

    while (num > 0) {
        int rem = num % 3;
        num /= 3;
        ss << rem;
    }

    auto str = ss.str();
    std::reverse(str.begin(), str.end());
    return str;
}

bool nextResult() {
    if (results == "222222") {
        return false;
    }

    auto res = fromBase3(results);

    std::stringstream ss;
    ss << std::setw(6) << std::setfill('0') << toBase3(res + 1);
    results = ss.str();

    return true;
}

int main() {
    std::array<std::array<int, 10>, 4> points;
    for (auto &row : points) {
        std::fill(row.begin(), row.end(), 0);
    }

    do {
        std::array<int, 4> records {0, 0, 0, 0 };

        for (size_t i = 0; i < games.size(); i++) {
            switch (results[i]) {
            case '2':
                records[games[i][0] - '1'] += 3;
                break;
            case '1':
                records[games[i][0] - '1']++;
                records[games[i][1] - '1']++;
                break;
            case '0':
                records[games[i][1] - '1'] += 3;
                break;
            default:
                break;
            }
        }

        std::sort(records.begin(), records.end());
        for (size_t i = 0; i < records.size(); i++) {
            points[i][records[i]]++;
        }
    } while (nextResult());

    std::cout << "POINTS       0    1    2    3    4    5    6    7    8    9\n";
    std::cout << "-------------------------------------------------------------\n";
    std::array<std::string, 4> places{ "1st", "2nd", "3rd", "4th" };
    for (size_t i = 0; i < places.size(); i++) {
        std::cout << places[i] << " place";
        for (size_t j = 0; j < points[i].size(); j++) {
            std::cout << std::setw(5) << points[3 - i][j];
        }
        std::cout << '\n';
    }
    return 0;
}
