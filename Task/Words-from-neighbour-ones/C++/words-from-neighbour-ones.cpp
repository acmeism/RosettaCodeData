#include <algorithm>
#include <cstdlib>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

int main(int argc, char** argv) {
    const int min_length = 9;
    const char* filename(argc < 2 ? "unixdict.txt" : argv[1]);
    std::ifstream in(filename);
    if (!in) {
        std::cerr << "Cannot open file '" << filename << "'.\n";
        return EXIT_FAILURE;
    }
    std::string line;
    std::vector<std::string> words;
    while (getline(in, line)) {
        if (line.size() >= min_length)
            words.push_back(line);
    }
    std::sort(words.begin(), words.end());
    std::string previous_word;
    int count = 0;
    for (size_t i = 0, n = words.size(); i + min_length <= n; ++i) {
        std::string word;
        word.reserve(min_length);
        for (size_t j = 0; j < min_length; ++j)
            word += words[i + j][j];
        if (previous_word == word)
            continue;
        auto w = std::lower_bound(words.begin(), words.end(), word);
        if (w != words.end() && *w == word)
            std::cout << std::setw(2) << ++count << ". " << word << '\n';
        previous_word = word;
    }
    return EXIT_SUCCESS;
}
