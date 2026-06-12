#include <cstdlib>
#include <fstream>
#include <iostream>

bool is_abc_word(const std::string& word) {
    bool a = false;
    bool b = false;
    for (char ch : word) {
        switch (ch) {
        case 'a':
            if (!a)
                a = true;
            break;
        case 'b':
            if (!b) {
                // fail if we haven't seen 'a' yet
                if (!a)
                    return false;
                b = true;
            }
            break;
        case 'c':
            // succeed iff we've seen 'b' already
            return b;
        }
    }
    return false;
}

int main(int argc, char** argv) {
    const char* filename(argc < 2 ? "unixdict.txt" : argv[1]);
    std::ifstream in(filename);
    if (!in) {
        std::cerr << "Cannot open file '" << filename << "'.\n";
        return EXIT_FAILURE;
    }
    std::string word;
    int n = 1;
    while (getline(in, word)) {
        if (is_abc_word(word))
            std::cout << n++ << ": " << word << '\n';
    }
    return EXIT_SUCCESS;
}
