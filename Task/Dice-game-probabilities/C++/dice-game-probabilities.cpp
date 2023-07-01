#include <cmath>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <map>

// Returns map from sum of faces to number of ways it can happen
std::map<uint32_t, uint32_t> get_totals(uint32_t dice, uint32_t faces) {
    std::map<uint32_t, uint32_t> result;
    for (uint32_t i = 1; i <= faces; ++i)
        result.emplace(i, 1);
    for (uint32_t d = 2; d <= dice; ++d) {
        std::map<uint32_t, uint32_t> tmp;
        for (const auto& p : result) {
            for (uint32_t i = 1; i <= faces; ++i)
                tmp[p.first + i] += p.second;
        }
        tmp.swap(result);
    }
    return result;
}

double probability(uint32_t dice1, uint32_t faces1, uint32_t dice2, uint32_t faces2) {
    auto totals1 = get_totals(dice1, faces1);
    auto totals2 = get_totals(dice2, faces2);
    double wins = 0;
    for (const auto& p1 : totals1) {
        for (const auto& p2 : totals2) {
            if (p2.first >= p1.first)
                break;
            wins += p1.second * p2.second;
        }
    }
    double total = std::pow(faces1, dice1) * std::pow(faces2, dice2);
    return wins/total;
}

int main() {
    std::cout << std::setprecision(10);
    std::cout << probability(9, 4, 6, 6) << '\n';
    std::cout << probability(5, 10, 6, 7) << '\n';
    return 0;
}
