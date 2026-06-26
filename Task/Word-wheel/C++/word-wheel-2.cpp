#include <algorithm>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <string>
#include <tuple>
#include <vector>

int main() {
    std::vector<std::string> words;

    // Part 1
    {
        const std::string wheel = "ndeokgelw";
        const char center = wheel[4];

        std::ifstream file_stream{"../unixdict.txt"};
        std::string word;
        while (file_stream >> word) {
            words.push_back(word);

            if (word.length() < 3 || word.find(center) == std::string::npos)
                continue;

            for (const char letter : wheel) {
                const std::size_t idx = word.find(letter);

                if (idx != std::string::npos)
                    word[idx] = ' ';
            }

            if (std::count(word.begin(), word.end(), ' ') == word.length())
                std::cout << words.back() << '\n';
        }
    }

    // Part 2
    {
        std::uint32_t max_words_found = 0;
        std::vector<std::pair<std::string, char>> best;

        for (const std::string &wheel : words) {
            if (wheel.length() != 9)
                continue;

            for (const char center : wheel) {
                std::uint32_t words_found = 0;

                for (std::string word : words) {
                    if (word.length() < 3 || word.find(center) == std::string::npos)
                        continue;

                    for (const char letter : wheel) {
                        const std::size_t idx = word.find(letter);

                        if (idx != std::string::npos)
                            word[idx] = ' ';
                    }

                    if (std::count(word.begin(), word.end(), ' ') == word.length())
                        words_found++;
                }

                if (words_found > max_words_found) {
                    max_words_found = words_found;

                    best.clear();
                    best.emplace_back(wheel, center);
                } else if (words_found == max_words_found) {
                    best.emplace_back(wheel, center);
                }
            }
        }

        std::cout << "\nMost words found = " << max_words_found
                  << "\nThe nine letter words producing this total are:\n";
        for (const std::pair<std::string, char> &p : best) {
            std::cout << p.first << " with central letter '" << p.second << "'\n";
        }
    }
}
