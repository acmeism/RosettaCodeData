#include <algorithm>
#include <cstdlib>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

int main() {
    std::vector<std::string> words;
    std::ifstream in("words.txt");
    if (!in) {
        std::cerr << "Cannot open file words.txt.\n";
        return EXIT_FAILURE;
    }
    std::string line;
    while (getline(in, line)) {
        if (line.size() > 6)
            words.push_back(line);
    }
    sort(words.begin(), words.end());
    for (const std::string& word : words) {
        std::string reversed(word.rbegin(), word.rend());
        if (reversed > word &&
            binary_search(words.begin(), words.end(), reversed)) {
            std::cout << std::setw(8) << word << " <-> " << reversed << '\n';
        }
    }
    return EXIT_SUCCESS;
}
