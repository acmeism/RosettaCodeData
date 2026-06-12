#include <algorithm>
#include <iostream>
#include <type_traits>
#include <vector>

template <typename Iterator, typename Function>
void decorate_sort_undecorate(Iterator begin, Iterator end, Function f) {
    using ValueType = typename std::iterator_traits<Iterator>::value_type;
    using KeyType = std::invoke_result_t<Function, ValueType>;
    using KeyValue = std::pair<KeyType, ValueType>;
    std::vector<KeyValue> tmp;
    tmp.reserve(std::distance(begin, end));
    std::transform(begin, end, std::back_inserter(tmp), [&f](ValueType& v) {
        return std::make_pair(f(v), std::move(v));
    });
    std::sort(tmp.begin(), tmp.end(), [](const KeyValue& a, const KeyValue& b) {
        return a.first < b.first;
    });
    std::transform(tmp.begin(), tmp.end(), begin,
                   [](KeyValue& p) { return std::move(p.second); });
}

int main() {
    std::string test[] = {"Rosetta",     "Code",         "is",  "a",
                          "programming", "chrestomathy", "site"};
    decorate_sort_undecorate(std::begin(test), std::end(test),
                             [](const std::string& s) { return s.size(); });
    for (const std::string& s : test)
        std::cout << s << ' ';
    std::cout << '\n';
}
