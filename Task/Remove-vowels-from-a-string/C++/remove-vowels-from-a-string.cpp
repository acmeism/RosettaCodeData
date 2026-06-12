#include <algorithm>
#include <iostream>

class print_no_vowels {
private:
    const std::string &str;
public:
    print_no_vowels(const std::string &s) : str(s) {}
    friend std::ostream &operator<<(std::ostream &, print_no_vowels);
};

std::ostream &operator<<(std::ostream &os, print_no_vowels pnv) {
    auto it = pnv.str.cbegin();
    auto end = pnv.str.cend();
    std::for_each(
        it, end,
        [&os](char c) {
            switch (c) {
            case 'A':
            case 'E':
            case 'I':
            case 'O':
            case 'U':
            case 'a':
            case 'e':
            case 'i':
            case 'o':
            case 'u':
                break;
            default:
                os << c;
                break;
            }
        }
    );
    return os;
}

void test(const std::string &s) {
    std::cout << "Input  : " << s << '\n';
    std::cout << "Output : " << print_no_vowels(s) << '\n';
}

int main() {
    test("C++ Programming Language");
    return 0;
}
