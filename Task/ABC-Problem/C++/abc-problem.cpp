#include <iostream>
#include <vector>
#include <string>
#include <set>
#include <cctype>


typedef std::pair<char,char> item_t;
typedef std::vector<item_t> list_t;

bool can_make_word(const std::string& w, const list_t& vals) {
    std::set<uint32_t> used;
    while (used.size() < w.size()) {
        const char c = toupper(w[used.size()]);
        uint32_t x = used.size();
        for (uint32_t i = 0, ii = vals.size(); i < ii; ++i) {
            if (used.find(i) == used.end()) {
                if (toupper(vals[i].first) == c || toupper(vals[i].second) == c) {
                    used.insert(i);
                    break;
                }
            }
        }
        if (x == used.size()) break;
    }
    return used.size() == w.size();
}


int main() {
    list_t vals{ {'B','O'}, {'X','K'}, {'D','Q'}, {'C','P'}, {'N','A'}, {'G','T'}, {'R','E'}, {'T','G'}, {'Q','D'}, {'F','S'}, {'J','W'}, {'H','U'}, {'V','I'}, {'A','N'}, {'O','B'}, {'E','R'}, {'F','S'}, {'L','Y'}, {'P','C'}, {'Z','M'} };
    std::vector<std::string> words{"A","BARK","BOOK","TREAT","COMMON","SQUAD","CONFUSE"};
    for (const std::string& w : words) {
        std::cout << w << ": " << std::boolalpha << can_make_word(w,vals) << ".\n";
    }

}
