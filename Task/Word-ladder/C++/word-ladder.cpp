#include <algorithm>
#include <fstream>
#include <iostream>
#include <map>
#include <string>
#include <vector>

using word_map = std::map<size_t, std::vector<std::string>>;

// Returns true if strings s1 and s2 differ by one character.
bool one_away(const std::string& s1, const std::string& s2) {
    if (s1.size() != s2.size())
        return false;
    bool result = false;
    for (size_t i = 0, n = s1.size(); i != n; ++i) {
        if (s1[i] != s2[i]) {
            if (result)
                return false;
            result = true;
        }
    }
    return result;
}

// Join a sequence of strings into a single string using the given separator.
template <typename iterator_type, typename separator_type>
std::string join(iterator_type begin, iterator_type end,
                 separator_type separator) {
    std::string result;
    if (begin != end) {
        result += *begin++;
        for (; begin != end; ++begin) {
            result += separator;
            result += *begin;
        }
    }
    return result;
}

// If possible, print the shortest chain of single-character modifications that
// leads from "from" to "to", with each intermediate step being a valid word.
// This is an application of breadth-first search.
bool word_ladder(const word_map& words, const std::string& from,
                 const std::string& to) {
    auto w = words.find(from.size());
    if (w != words.end()) {
        auto poss = w->second;
        std::vector<std::vector<std::string>> queue{{from}};
        while (!queue.empty()) {
            auto curr = queue.front();
            queue.erase(queue.begin());
            for (auto i = poss.begin(); i != poss.end();) {
                if (!one_away(*i, curr.back())) {
                    ++i;
                    continue;
                }
                if (to == *i) {
                    curr.push_back(to);
                    std::cout << join(curr.begin(), curr.end(), " -> ") << '\n';
                    return true;
                }
                std::vector<std::string> temp(curr);
                temp.push_back(*i);
                queue.push_back(std::move(temp));
                i = poss.erase(i);
            }
        }
    }
    std::cout << from << " into " << to << " cannot be done.\n";
    return false;
}

int main() {
    word_map words;
    std::ifstream in("unixdict.txt");
    if (!in) {
        std::cerr << "Cannot open file unixdict.txt.\n";
        return EXIT_FAILURE;
    }
    std::string word;
    while (getline(in, word))
        words[word.size()].push_back(word);
    word_ladder(words, "boy", "man");
    word_ladder(words, "girl", "lady");
    word_ladder(words, "john", "jane");
    word_ladder(words, "child", "adult");
    word_ladder(words, "cat", "dog");
    word_ladder(words, "lead", "gold");
    word_ladder(words, "white", "black");
    word_ladder(words, "bubble", "tickle");
    return EXIT_SUCCESS;
}
