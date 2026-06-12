#include <cstdlib>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <string>

bool is_vowel(char ch) {
    switch (ch) {
    case 'a': case 'A':
    case 'e': case 'E':
    case 'i': case 'I':
    case 'o': case 'O':
    case 'u': case 'U':
        return true;
    }
    return false;
}

bool alternating_vowels_and_consonants(const std::string& str) {
    for (size_t i = 1, len = str.size(); i < len; ++i) {
        if (is_vowel(str[i]) == is_vowel(str[i - 1]))
            return false;
    }
    return true;
}

int main(int argc, char** argv) {
    const char* filename = argc < 2 ? "unixdict.txt" : argv[1];
    std::ifstream in(filename);
    if (!in) {
        std::cerr << "Cannot open file '" << filename << "'.\n";
        return EXIT_FAILURE;
    }
    std::string line;
    for (int n = 1; getline(in, line); ) {
        if (line.size() > 9 && alternating_vowels_and_consonants(line))
            std::cout << std::setw(2) << n++ << ": " << line << '\n';
    }
    return EXIT_SUCCESS;
}
