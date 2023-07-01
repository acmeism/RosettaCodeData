#include <algorithm>
#include <iostream>
#include <format>
#include <fstream>
#include <map>
#include <ranges>
#include <regex>
#include <string>
#include <vector>

int main() {
    std::ifstream in("135-0.txt");
    std::string text{
        std::istreambuf_iterator<char>{in}, std::istreambuf_iterator<char>{}
    };
    in.close();

    std::regex word_rx("\\w+");
    std::map<std::string, int> freq;
    for (const auto& a : std::ranges::subrange(
        std::sregex_iterator{ text.cbegin(),text.cend(), word_rx }, std::sregex_iterator{}
    ))
    {
        auto word = a.str();
        transform(word.begin(), word.end(), word.begin(), ::tolower);
        freq[word]++;
    }

    std::vector<std::pair<std::string, int>> pairs;
    for (const auto& elem : freq)
    {
        pairs.push_back(elem);
    }

    std::ranges::sort(pairs, std::ranges::greater{}, &std::pair<std::string, int>::second);

    std::cout << "Rank  Word  Frequency\n"
        "====  ====  =========\n";
    for (int rank=1; const auto& [word, count] : pairs | std::views::take(10))
    {
        std::cout << std::format("{:2}   {:>4}   {:5}\n", rank++, word, count);
    }
}
