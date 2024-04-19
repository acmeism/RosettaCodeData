#include <iostream>
#include <string_view>

void all_characters_are_the_same(std::string_view str) {
    size_t len = str.length();
    std::cout << "input: \"" << str << "\", length: " << len << '\n';
    if (len > 0) {
        char ch = str[0];
        for (size_t i = 1; i < len; ++i) {
            if (str[i] != ch) {
                std::cout << "Not all characters are the same.\n";
                std::cout << "Character '" << str[i] << "' (hex " << std::hex
                          << static_cast<unsigned int>(str[i])
                          << ") at position " << std::dec << i + 1
                          << " is not the same as '" << ch << "'.\n\n";
                return;
            }
        }
    }
    std::cout << "All characters are the same.\n\n";
}

int main() {
    all_characters_are_the_same("");
    all_characters_are_the_same("   ");
    all_characters_are_the_same("2");
    all_characters_are_the_same("333");
    all_characters_are_the_same(".55");
    all_characters_are_the_same("tttTTT");
    all_characters_are_the_same("4444 444k");
    return 0;
}
