#include <algorithm>
#include <cctype>
#include <string>
#include <iostream>

const std::string alphabet("abcdefghijklmnopqrstuvwxyz");

bool is_pangram(std::string s)
{
    std::transform(s.begin(), s.end(), s.begin(), ::tolower);
    std::sort(s.begin(), s.end());
    return std::includes(s.begin(), s.end(), alphabet.begin(), alphabet.end());
}

int main()
{
    const auto examples = {"The quick brown fox jumps over the lazy dog",
                           "The quick white cat jumps over the lazy dog"};

    std::cout.setf(std::ios::boolalpha);
    for (auto& text : examples) {
        std::cout << "Is \"" << text << "\" a pangram? - " << is_pangram(text) << std::endl;
    }
}
