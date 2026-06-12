#include <algorithm>
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
    const int min_length = 6;
    std::string word;
    std::set<std::string> dictionary;
    while (getline(in, word)) {
        if (word.size() >= min_length)
            dictionary.insert(word);
    }
    int count = 0;
    for (const std::string& word1 : dictionary) {
        if (word1.find('e') == std::string::npos)
            continue;
        std::string word2(word1);
        std::replace(word2.begin(), word2.end(), 'e', 'i');
        if (dictionary.find(word2) != dictionary.end()) {
            std::cout << std::right << std::setw(2) << ++count
                << ". " << std::left << std::setw(10) << word1
                << " -> " << word2 << '\n';
        }
    }

    return EXIT_SUCCESS;
}
