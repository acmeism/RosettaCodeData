#include <iostream>
#include <fstream>

int main() {
    std::string word;
    std::ifstream file("unixdict.txt");

    if (!file) {
        std::cerr << "Cannot open unixdict.txt" << std::endl;
        return -1;
    }
    while (file >> word) {
        if (word.length() > 11 && word.find("the") != std::string::npos)
            std::cout << word << std::endl;
    }
    return 0;
}
