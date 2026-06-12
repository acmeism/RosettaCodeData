#include <cstdlib>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

int hamming_distance(const std::string& str1, const std::string& str2) {
    size_t len1 = str1.size();
    size_t len2 = str2.size();
    if (len1 != len2)
        return 0;
    int count = 0;
    for (size_t i = 0; i < len1; ++i) {
        if (str1[i] != str2[i])
            ++count;
        // don't care about counts > 2 in this case
        if (count == 2)
            break;
    }
    return count;
}

int main(int argc, char** argv) {
    const char* filename(argc < 2 ? "unixdict.txt" : argv[1]);
    std::ifstream in(filename);
    if (!in) {
        std::cerr << "Cannot open file '" << filename << "'.\n";
        return EXIT_FAILURE;
    }
    std::string line;
    std::vector<std::string> dictionary;
    while (getline(in, line)) {
        if (line.size() > 11)
            dictionary.push_back(line);
    }
    std::cout << "Changeable words in " << filename << ":\n";
    int n = 1;
    for (const std::string& word1 : dictionary) {
        for (const std::string& word2 : dictionary) {
            if (hamming_distance(word1, word2) == 1)
                std::cout << std::setw(2) << std::right << n++
                    << ": " << std::setw(14) << std::left << word1
                    << " -> " << word2 << '\n';
        }
    }
    return EXIT_SUCCESS;
}
