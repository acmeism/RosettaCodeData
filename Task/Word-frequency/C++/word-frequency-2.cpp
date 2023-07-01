#include <algorithm>
#include <iostream>
#include <fstream>
#include <map>
#include <regex>
#include <string>
#include <vector>

int main() {
    std::regex wordRgx("\\w+");
    std::map<std::string, int> freq;
    std::string line;
    const int top = 10;

    std::ifstream in("135-0.txt");
    if (!in.is_open()) {
        std::cerr << "Failed to open file\n";
        return 1;
    }
    while (std::getline(in, line)) {
        auto words_itr = std::sregex_iterator(
            line.cbegin(), line.cend(), wordRgx);
        auto words_end = std::sregex_iterator();
        while (words_itr != words_end) {
            auto match = *words_itr;
            auto word = match.str();
            if (word.size() > 0) {
                transform (word.begin(), word.end(), word.begin(), ::tolower);
                auto entry = freq.find(word);
                if (entry != freq.end()) {
                    entry->second++;
                } else {
                    freq.insert(std::make_pair(word, 1));
                }
            }
            words_itr = std::next(words_itr);
        }
    }
    in.close();

    std::vector<std::pair<std::string, int>> pairs;
    for (auto iter = freq.cbegin(); iter != freq.cend(); ++iter) {
        pairs.push_back(*iter);
    }
    std::sort(pairs.begin(), pairs.end(), [](auto& a, auto& b) {
        return a.second > b.second;
    });

    std::cout << "Rank  Word  Frequency\n"
                 "====  ====  =========\n";
    int rank = 1;
    for (auto iter = pairs.cbegin(); iter != pairs.cend() && rank <= top; ++iter) {
        std::printf("%2d   %4s   %5d\n", rank++, iter->first.c_str(), iter->second);
    }

    return 0;
}
