#include <algorithm>
#include <cctype>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <iterator>
#include <set>
#include <sstream>
#include <string>
#include <vector>

using bigram = std::pair<char, char>;

std::multiset<bigram> bigrams(const std::string& phrase) {
    std::multiset<bigram> result;
    std::istringstream is(phrase);
    std::string word;
    while (is >> word) {
        for (char& ch : word) {
            ch = std::tolower(static_cast<unsigned char>(ch));
        }
        size_t length = word.size();
        if (length == 1) {
            result.emplace(word[0], '\0');
        } else {
            for (size_t i = 0; i + 1 < length; ++i) {
                result.emplace(word[i], word[i + 1]);
            }
        }
    }
    return result;
}

double sorensen(const std::string& s1, const std::string& s2) {
    auto a = bigrams(s1);
    auto b = bigrams(s2);
    std::multiset<bigram> c;
    std::set_intersection(a.begin(), a.end(), b.begin(), b.end(),
                          std::inserter(c, c.begin()));
    return (2.0 * c.size()) / (a.size() + b.size());
}

int main() {
    std::vector<std::string> tasks;
    std::ifstream is("tasks.txt");
    if (!is) {
        std::cerr << "Cannot open tasks file.\n";
        return EXIT_FAILURE;
    }
    std::string task;
    while (getline(is, task)) {
        tasks.push_back(task);
    }
    const size_t tc = tasks.size();
    const std::string tests[] = {"Primordial primes",
                                 "Sunkist-Giuliani formula",
                                 "Sieve of Euripides", "Chowder numbers"};
    std::vector<std::pair<double, size_t>> sdi(tc);
    std::cout << std::fixed;
    for (const std::string& test : tests) {
        for (size_t i = 0; i != tc; ++i) {
            sdi[i] = std::make_pair(sorensen(tasks[i], test), i);
        }
        std::partial_sort(sdi.begin(), sdi.begin() + 5, sdi.end(),
                          [](const std::pair<double, size_t>& a,
                             const std::pair<double, size_t>& b) {
                              return a.first > b.first;
                          });
        std::cout << test << " >\n";
        for (size_t i = 0; i < 5 && i < tc; ++i) {
            std::cout << "  " << sdi[i].first << ' ' << tasks[sdi[i].second]
                      << '\n';
        }
        std::cout << '\n';
    }
    return EXIT_SUCCESS;
}
