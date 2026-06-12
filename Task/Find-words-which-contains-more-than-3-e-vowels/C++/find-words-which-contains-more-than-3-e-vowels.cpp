#include <iostream>
#include <fstream>

bool test(const std::string &line) {
    unsigned int e = 0;
    for (char c : line) {
        switch(std::tolower(c)) {
            case 'a': return false;
            case 'i': return false;
            case 'o': return false;
            case 'u': return false;
            case 'e': ++e;
        }
    }
    return e > 3;
}

int main() {
    std::ifstream dict{"unixdict.txt"};

    if (! dict.is_open()) {
        std::cerr << "Cannot open unixdict.txt\n";
        return 3;
    }

    for (std::string line; std::getline(dict, line);) {
        if (test(line)) std::cout << line << std::endl;
    }

    return 0;
}
