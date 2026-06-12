#include <algorithm>
#include <iostream>
#include <optional>
#include <set>
#include <string>
#include <string_view>
#include <vector>

struct string_comparator {
    using is_transparent = void;
    bool operator()(const std::string& lhs, const std::string& rhs) const {
        return lhs < rhs;
    }
    bool operator()(const std::string& lhs, const std::string_view& rhs) const {
        return lhs < rhs;
    }
    bool operator()(const std::string_view& lhs, const std::string& rhs) const {
        return lhs < rhs;
    }
};

using dictionary = std::set<std::string, string_comparator>;

template <typename iterator, typename separator>
std::string join(iterator begin, iterator end, separator sep) {
    std::string result;
    if (begin != end) {
        result += *begin++;
        for (; begin != end; ++begin) {
            result += sep;
            result += *begin;
        }
    }
    return result;
}

auto create_string(const std::string_view& s,
                   const std::vector<std::optional<size_t>>& v) {
    auto idx = s.size();
    std::vector<std::string_view> sv;
    while (v[idx].has_value()) {
        size_t prev = v[idx].value();
        sv.push_back(s.substr(prev, idx - prev));
        idx = prev;
    }
    std::reverse(sv.begin(), sv.end());
    return join(sv.begin(), sv.end(), ' ');
}

std::optional<std::string> word_break(const std::string_view& str,
                                      const dictionary& dict) {
    auto size = str.size() + 1;
    std::vector<std::optional<size_t>> possible(size);
    auto check_word = [&dict, &str](size_t i, size_t j)
            -> std::optional<size_t> {
        if (dict.find(str.substr(i, j - i)) != dict.end())
            return i;
        return std::nullopt;
    };
    for (size_t i = 1; i < size; ++i) {
        if (!possible[i].has_value())
            possible[i] = check_word(0, i);
        if (possible[i].has_value()) {
            for (size_t j = i + 1; j < size; ++j) {
                if (!possible[j].has_value())
                    possible[j] = check_word(i, j);
            }
            if (possible[str.size()].has_value())
                return create_string(str, possible);
        }
    }
    return std::nullopt;
}

int main(int argc, char** argv) {
    dictionary dict;
    dict.insert("a");
    dict.insert("bc");
    dict.insert("abc");
    dict.insert("cd");
    dict.insert("b");
    auto result = word_break("abcd", dict);
    if (result.has_value())
        std::cout << result.value() << '\n';
    return 0;
}
