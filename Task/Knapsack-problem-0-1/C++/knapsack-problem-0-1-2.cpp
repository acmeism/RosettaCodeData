#include <iomanip>
#include <iostream>
#include <set>
#include <string>
#include <tuple>
#include <vector>

std::tuple<std::set<int>, int> findBestPack(const std::vector<std::tuple<std::string, int, int> > &items, const int weightlimit) {
    const auto n = items.size();
    int bestValues[n][weightlimit] = { 0 };
    std::set<int> solutionSets[n][weightlimit];
    std::set<int> bestItems;
    for (auto i = 0u; i < n; i++)
        for (auto weight = 0; weight < weightlimit; weight++) {
            if (i == 0)
                bestValues[i][weight] = 0;
            else {
                auto [_, itemweight, value] = *(items.begin() + i);
                if (weight < itemweight) {
                    bestValues[i][weight] = bestValues[i - 1][weight];
                    solutionSets[i][weight] = solutionSets[i - 1][weight];
                } else {
                    if (bestValues[i - 1][weight - itemweight] + value > bestValues[i - 1][weight]) {
                        bestValues[i][weight] = bestValues[i - 1][weight - itemweight] + value;
                        solutionSets[i][weight] = solutionSets[i - 1][weight - itemweight];
                        solutionSets[i][weight].insert(i);
                    } else {
                        bestValues[i][weight] = bestValues[i - 1][weight];
                        solutionSets[i][weight] = solutionSets[i - 1][weight];
                    }
                }
            }
        }

    bestItems.swap(solutionSets[n - 1][weightlimit - 1]);
    return { bestItems, bestValues[n - 1][weightlimit - 1] };
}

int main() {
    const std::vector<std::tuple<std::string, int, int>> items = {
            { "", 0, 0 },
            { "map", 9, 150 },
            { "compass", 13, 35 },
            { "water", 153, 200 },
            { "sandwich", 50, 160 },
            { "glucose", 15, 60 },
            { "tin", 68, 45 },
            { "banana", 27, 60 },
            { "apple", 39, 40 },
            { "cheese", 23, 30 },
            { "beer", 52, 10 },
            { "suntan creme", 11, 70 },
            { "camera", 32, 30 },
            { "T-shirt", 24, 15 },
            { "trousers", 48, 10 },
            { "umbrella", 73, 40 },
            { "waterproof trousers", 42, 70 },
            { "waterproof overclothes", 43, 75 },
            { "note-case", 22, 80 },
            { "sunglasses", 7, 20 },
            { "towel", 18, 12 },
            { "socks", 4, 50 },
            { "book", 30, 10 } };

    const int maximumWeight = 400;
    const auto &[bestItems, bestValue] = findBestPack(items, maximumWeight);
    int totalweight = 0;
    std::cout << std::setw(24) << "best knapsack:" << std::endl;
    for (auto si = bestItems.begin(); si != bestItems.end(); si++) {
       auto [name, weight, value] = *(items.begin() + *si);
       std::cout << std::setw(24) << name << std::setw(6) << weight << std::setw(6) << value << std::endl;
       totalweight += weight;
    }
    std::cout << std::endl << std::setw(24) << "total:" << std::setw(6) << totalweight << std::setw(6) << bestValue << std::endl;
    return 0;
}
