#include <algorithm>
#include <fstream>
#include <iostream>
#include <set>
#include <string>
#include <vector>

// filename is expected to contain one lowercase word per line
std::set<std::string> load_dictionary(const std::string& filename) {
    std::ifstream in(filename);
    if (!in)
        throw std::runtime_error("Cannot open file " + filename);
    std::set<std::string> words;
    std::string word;
    while (getline(in, word))
        words.insert(word);
    return words;
}

void find_teacup_words(const std::set<std::string>& words) {
    std::vector<std::string> teacup_words;
    std::set<std::string> found;
    for (auto w = words.begin(); w != words.end(); ++w) {
        std::string word = *w;
        size_t len = word.size();
        if (len < 3 || found.find(word) != found.end())
            continue;
        teacup_words.clear();
        teacup_words.push_back(word);
        for (size_t i = 0; i + 1 < len; ++i) {
            std::rotate(word.begin(), word.begin() + 1, word.end());
            if (word == *w || words.find(word) == words.end())
                break;
            teacup_words.push_back(word);
        }
        if (teacup_words.size() == len) {
            found.insert(teacup_words.begin(), teacup_words.end());
            std::cout << teacup_words[0];
            for (size_t i = 1; i < len; ++i)
                std::cout << ' ' << teacup_words[i];
            std::cout << '\n';
        }
    }
}

int main(int argc, char** argv) {
    if (argc != 2) {
        std::cerr << "usage: " << argv[0] << " dictionary\n";
        return EXIT_FAILURE;
    }
    try {
        find_teacup_words(load_dictionary(argv[1]));
    } catch (const std::exception& ex) {
        std::cerr << ex.what() << '\n';
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}
