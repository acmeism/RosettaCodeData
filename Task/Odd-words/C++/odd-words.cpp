#include <cstdlib>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <set>
#include <string>
#include <utility>
#include <vector>

using word_list = std::vector<std::pair<std::string, std::string>>;

void print_words(std::ostream& out, const word_list& words) {
    int n = 1;
    for (const auto& pair : words) {
        out << std::right << std::setw(2) << n++ << ": "
            << std::left << std::setw(14) << pair.first
            << pair.second << '\n';
    }
}

int main(int argc, char** argv) {
    const char* filename(argc < 2 ? "unixdict.txt" : argv[1]);
    std::ifstream in(filename);
    if (!in) {
        std::cerr << "Cannot open file '" << filename << "'.\n";
        return EXIT_FAILURE;
    }
    const int min_length = 5;
    std::string line;
    std::set<std::string> dictionary;
    while (getline(in, line)) {
        if (line.size() >= min_length)
            dictionary.insert(line);
    }

    word_list odd_words, even_words;

    for (const std::string& word : dictionary) {
        if (word.size() < min_length + 2*(min_length/2))
            continue;
        std::string odd_word, even_word;
        for (auto w = word.begin(); w != word.end(); ++w) {
            odd_word += *w;
            if (++w == word.end())
                break;
            even_word += *w;
        }

        if (dictionary.find(odd_word) != dictionary.end())
            odd_words.emplace_back(word, odd_word);

        if (dictionary.find(even_word) != dictionary.end())
            even_words.emplace_back(word, even_word);
    }

    std::cout << "Odd words:\n";
    print_words(std::cout, odd_words);

    std::cout << "\nEven words:\n";
    print_words(std::cout, even_words);

    return EXIT_SUCCESS;
}
