#include <iostream>
#include <codecvt>
int main()
{
    std::string utf8 = "\x7a\xc3\x9f\xe6\xb0\xb4\xf0\x9d\x84\x8b"; // U+007a, U+00df, U+6c34, U+1d10b
    std::cout << "Byte length: " << utf8.size() << '\n';
    std::wstring_convert<std::codecvt_utf8<char32_t>, char32_t> conv;
    std::cout << "Character length: " << conv.from_bytes(utf8).size() << '\n';
}
