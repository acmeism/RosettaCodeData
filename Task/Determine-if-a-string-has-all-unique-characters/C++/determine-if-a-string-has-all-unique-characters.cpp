#include <iostream>
#include <string>

void string_has_repeated_character(const std::string& str) {
    size_t len = str.length();
    std::cout << "input: \"" << str << "\", length: " << len << '\n';
    for (size_t i = 0; i < len; ++i) {
        for (size_t j = i + 1; j < len; ++j) {
            if (str[i] == str[j]) {
                std::cout << "String contains a repeated character.\n";
                std::cout << "Character '" << str[i]
                    << "' (hex " << std::hex << static_cast<unsigned int>(str[i])
                    << ") occurs at positions " << std::dec << i + 1
                    << " and " << j + 1 << ".\n\n";
                return;
            }
        }
    }
    std::cout << "String contains no repeated characters.\n\n";
}

int main() {
    string_has_repeated_character("");
    string_has_repeated_character(".");
    string_has_repeated_character("abcABC");
    string_has_repeated_character("XYZ ZYX");
    string_has_repeated_character("1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ");
    return 0;
}
