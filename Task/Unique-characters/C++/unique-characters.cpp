#include <iostream>
#include <map>

int main() {
    const char* strings[] = {"133252abcdeeffd", "a6789798st", "yxcdfgxcyz"};
    std::map<char, int> count;
    for (const char* str : strings) {
        for (; *str; ++str)
            ++count[*str];
    }
    for (const auto& p : count) {
        if (p.second == 1)
            std::cout << p.first;
    }
    std::cout << '\n';
}
