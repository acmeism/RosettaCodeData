#include <algorithm>
#include <cstdlib>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

auto load_dictionary(const std::string& path) {
    std::ifstream in(path);
    if (!in)
        throw std::runtime_error("Cannot open file " + path);
    std::string line;
    std::vector<std::string> words;
    while (getline(in, line))
        words.push_back(line);
    return words;
}

double jaro_winkler_distance(std::string str1, std::string str2) {
    size_t len1 = str1.size();
    size_t len2 = str2.size();
    if (len1 < len2) {
        std::swap(str1, str2);
        std::swap(len1, len2);
    }
    if (len2 == 0)
        return len1 == 0 ? 0.0 : 1.0;
    size_t delta = std::max(size_t(1), len1/2) - 1;
    std::vector<bool> flag(len2, false);
    std::vector<char> ch1_match;
    ch1_match.reserve(len1);
    for (size_t idx1 = 0; idx1 < len1; ++idx1) {
        char ch1 = str1[idx1];
        for (size_t idx2 = 0; idx2 < len2; ++idx2) {
            char ch2 = str2[idx2];
            if (idx2 <= idx1 + delta && idx2 + delta >= idx1
                && ch1 == ch2 && !flag[idx2]) {
                flag[idx2] = true;
                ch1_match.push_back(ch1);
                break;
            }
        }
    }
    size_t matches = ch1_match.size();
    if (matches == 0)
        return 1.0;
    size_t transpositions = 0;
    for (size_t idx1 = 0, idx2 = 0; idx2 < len2; ++idx2) {
        if (flag[idx2]) {
            if (str2[idx2] != ch1_match[idx1])
                ++transpositions;
            ++idx1;
        }
    }
    double m = matches;
    double jaro = (m/len1 + m/len2 + (m - transpositions/2.0)/m)/3.0;
    size_t common_prefix = 0;
    len2 = std::min(size_t(4), len2);
    for (size_t i = 0; i < len2; ++i) {
        if (str1[i] == str2[i])
            ++common_prefix;
    }
    return 1.0 - (jaro + common_prefix * 0.1 * (1.0 - jaro));
}

auto within_distance(const std::vector<std::string>& words,
                     double max_distance, const std::string& str,
                     size_t max_to_return) {
    using pair = std::pair<std::string, double>;
    std::vector<pair> result;
    for (const auto& word : words) {
        double jaro = jaro_winkler_distance(word, str);
        if (jaro <= max_distance)
            result.emplace_back(word, jaro);
    }
    std::stable_sort(result.begin(), result.end(),
        [](const pair& p1, const pair& p2) { return p1.second < p2.second; });
    if (result.size() > max_to_return)
        result.resize(max_to_return);
    return result;
}

int main() {
    try {
        auto words(load_dictionary("linuxwords.txt"));
        std::cout << std::fixed << std::setprecision(4);
        for (auto str : {"accomodate", "definately", "goverment",
                            "occured", "publically", "recieve",
                            "seperate", "untill", "wich"}) {
            std::cout << "Close dictionary words (distance < 0.15 using Jaro-Winkler distance) to '"
                << str << "' are:\n        Word   |  Distance\n";
            for (const auto& pair : within_distance(words, 0.15, str, 5)) {
                std::cout << std::setw(14) << pair.first << " | "
                    << std::setw(6) << pair.second << '\n';
            }
            std::cout << '\n';
        }
    } catch (const std::exception& ex) {
        std::cerr << ex.what() << '\n';
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}
