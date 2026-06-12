#include <cstdlib>
#include <fstream>
#include <iostream>

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
        const size_t len = word.size();
        if (len > 5 && word.compare(0, 3, word, len - 3) == 0)
            std::cout << ++n << ": " << word << '\n';
    }
    return EXIT_SUCCESS;
}
