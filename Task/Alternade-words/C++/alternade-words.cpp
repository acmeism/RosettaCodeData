#include <cstdlib>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <set>
#include <string>

int main(int argc, char** argv) {
    const char* filename(argc < 2 ? "unixdict.txt" : argv[1]);
    std::ifstream in(filename);
    if (!in) {
        std::cerr << "Cannot open file '" << filename << "'.\n";
        return EXIT_FAILURE;
    }
    std::string line;
    std::set<std::string> dictionary;
    while (getline(in, line))
        dictionary.insert(line);
    std::cout << std::left;
    for (const std::string& word : dictionary) {
        size_t len = word.size();
        if (len < 6)
            continue;
        std::string word1, word2;
        for (size_t i = 0; i < len; i += 2) {
            word1 += word[i];
            if (i + 1 < len)
                word2 += word[i + 1];
        }
        if (dictionary.find(word1) != dictionary.end()
            && dictionary.find(word2) != dictionary.end()) {
            std::cout << std::setw(10) << word
                    << std::setw(6) << word1 << word2 << '\n';
        }
    }
    return EXIT_SUCCESS;
}
