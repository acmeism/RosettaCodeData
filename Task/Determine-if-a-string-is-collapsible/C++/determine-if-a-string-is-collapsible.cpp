#include <string>
#include <iostream>
#include <algorithm>

template<typename char_type>
std::basic_string<char_type> collapse(std::basic_string<char_type> str) {
    auto i = std::unique(str.begin(), str.end());
    str.erase(i, str.end());
    return str;
}

void test(const std::string& str) {
    std::cout << "original string: <<<" << str << ">>>, length = " << str.length() << '\n';
    std::string collapsed(collapse(str));
    std::cout << "result string: <<<" << collapsed << ">>>, length = " << collapsed.length() << '\n';
    std::cout << '\n';
}

int main(int argc, char** argv) {
    test("");
    test("\"If I were two-faced, would I be wearing this one?\" --- Abraham Lincoln ");
    test("..1111111111111111111111111111111111111111111111111111111111111117777888");
    test("I never give 'em hell, I just tell the truth, and they think it's hell. ");
    test("                                                    --- Harry S Truman  ");
    return 0;
}
