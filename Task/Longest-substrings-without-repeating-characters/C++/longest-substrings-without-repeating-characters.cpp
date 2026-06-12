#include <iostream>
#include <fstream>
#include <set>
#include <sstream>
#include <string>
#include <vector>

std::vector<std::string> longest_substrings_without_repeats(const std::string& str) {
    size_t max_length = 0;
    std::vector<std::string> result;
    size_t length = str.size();
    for (size_t offset = 0; offset < length; ++offset) {
        std::set<char> characters;
        size_t len = 0;
        for (; offset + len < length; ++len) {
            if (characters.find(str[offset + len]) != characters.end())
                break;
            characters.insert(str[offset + len]);
        }
        if (len > max_length) {
            result.clear();
            max_length = len;
        }
        if (len == max_length)
            result.push_back(str.substr(offset, max_length));
    }
    return result;
}

void print_strings(const std::vector<std::string>& strings) {
    std::cout << "[";
    for (size_t i = 0, n = strings.size(); i < n; ++i) {
        if (i > 0)
            std::cout << ", ";
        std::cout << '\'' << strings[i] << '\'';
    }
    std::cout << "]";
}

void test1() {
    for (std::string str : { "xyzyabcybdfd", "xyzyab", "zzzzz", "a", "thisisastringtest", "" }) {
        std::cout << "Input: '" << str << "'\nResult: ";
        print_strings(longest_substrings_without_repeats(str));
        std::cout << "\n\n";
    }
}

std::string slurp(std::istream& in) {
    std::ostringstream out;
    out << in.rdbuf();
    return out.str();
}

void test2(const std::string& filename) {
    std::ifstream in(filename);
    if (!in) {
        std::cerr << "Cannot open file '" << filename << "'.\n";
        return;
    }
    std::cout << "Longest substring with no repeats found in '" << filename << "': ";
    print_strings(longest_substrings_without_repeats(slurp(in)));
    std::cout << "\n";
}

int main() {
    test1();
    test2("unixdict.txt");
}
