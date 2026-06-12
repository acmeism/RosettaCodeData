#include <algorithm>
#include <fstream>
#include <iostream>
#include <numeric>
#include <string>
#include <vector>

// See https://en.wikipedia.org/wiki/Levenshtein_distance#Iterative_with_two_matrix_rows
int levenshtein_distance(const std::string& str1, const std::string& str2) {
    size_t m = str1.size(), n = str2.size();
    std::vector<int> cost(n + 1);
    std::iota(cost.begin(), cost.end(), 0);
    for (size_t i = 0; i < m; ++i) {
        cost[0] = i + 1;
        int prev = i;
        for (size_t j = 0; j < n; ++j) {
            int c = (str1[i] == str2[j]) ? prev
                : 1 + std::min(std::min(cost[j + 1], cost[j]), prev);
            prev = cost[j + 1];
            cost[j + 1] = c;
        }
    }
    return cost[n];
}

template <typename T>
void print_vector(const std::vector<T>& vec) {
    auto i = vec.begin();
    if (i == vec.end())
        return;
    std::cout << *i++;
    for (; i != vec.end(); ++i)
        std::cout << ", " << *i;
}

int main(int argc, char** argv) {
    if (argc != 3) {
        std::cerr << "usage: " << argv[0] << " dictionary word\n";
        return EXIT_FAILURE;
    }
    std::ifstream in(argv[1]);
    if (!in) {
        std::cerr << "Cannot open file " << argv[1] << '\n';
        return EXIT_FAILURE;
    }
    std::string word(argv[2]);
    if (word.empty()) {
        std::cerr << "Word must not be empty\n";
        return EXIT_FAILURE;
    }
    constexpr size_t max_dist = 4;
    std::vector<std::string> matches[max_dist + 1];
    std::string match;
    while (getline(in, match)) {
        int distance = levenshtein_distance(word, match);
        if (distance <= max_dist)
            matches[distance].push_back(match);
    }
    for (size_t dist = 0; dist <= max_dist; ++dist) {
        if (matches[dist].empty())
            continue;
        std::cout << "Words at Levenshtein distance of " << dist
            << " (" << 100 - (100 * dist)/word.size()
            << "% similarity) from '" << word << "':\n";
        print_vector(matches[dist]);
        std::cout << "\n\n";
    }
    return EXIT_SUCCESS;
}
