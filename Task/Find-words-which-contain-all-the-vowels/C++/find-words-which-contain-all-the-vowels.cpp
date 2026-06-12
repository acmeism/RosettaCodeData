#include <bitset>
#include <cctype>
#include <cstdlib>
#include <fstream>
#include <iomanip>
#include <iostream>

bool contains_all_vowels_once(const std::string& word) {
    std::bitset<5> vowels;
    for (char ch : word) {
        ch = std::tolower(static_cast<unsigned char>(ch));
        size_t bit = 0;
        switch (ch) {
        case 'a': bit = 0; break;
        case 'e': bit = 1; break;
        case 'i': bit = 2; break;
        case 'o': bit = 3; break;
        case 'u': bit = 4; break;
        default: continue;
        }
        if (vowels.test(bit))
            return false;
        vowels.set(bit);
    }
    return vowels.all();
}

int main(int argc, char** argv) {
    const char* filename(argc < 2 ? "unixdict.txt" : argv[1]);
    std::ifstream in(filename);
    if (!in) {
        std::cerr << "Cannot open file '" << filename << "'.\n";
        return EXIT_FAILURE;
    }
    std::string word;
    int n = 0;
    while (getline(in, word)) {
        if (word.size() > 10 && contains_all_vowels_once(word))
            std::cout << std::setw(2) << ++n << ": " << word << '\n';
    }
    return EXIT_SUCCESS;
}
