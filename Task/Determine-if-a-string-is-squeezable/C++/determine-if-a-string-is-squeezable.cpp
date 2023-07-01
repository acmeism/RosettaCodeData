#include <algorithm>
#include <string>
#include <iostream>

template<typename char_type>
std::basic_string<char_type> squeeze(std::basic_string<char_type> str, char_type ch) {
    auto i = std::unique(str.begin(), str.end(),
        [ch](char_type a, char_type b) { return a == ch && b == ch; });
    str.erase(i, str.end());
    return str;
}

void test(const std::string& str, char ch) {
    std::cout << "character: '" << ch << "'\n";
    std::cout << "original: <<<" << str << ">>>, length: " << str.length() << '\n';
    std::string squeezed(squeeze(str, ch));
    std::cout << "result: <<<" << squeezed << ">>>, length: " << squeezed.length() << '\n';
    std::cout << '\n';
}

int main(int argc, char** argv) {
    test("", ' ');
    test("\"If I were two-faced, would I be wearing this one?\" --- Abraham Lincoln ", '-');
    test("..1111111111111111111111111111111111111111111111111111111111111117777888", '7');
    test("I never give 'em hell, I just tell the truth, and they think it's hell. ", '.');
    std::string truman("                                                    --- Harry S Truman  ");
    test(truman, ' ');
    test(truman, '-');
    test(truman, 'r');
    return 0;
}
