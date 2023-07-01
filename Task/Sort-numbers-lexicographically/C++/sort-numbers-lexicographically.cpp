#include <algorithm>
#include <iostream>
#include <numeric>
#include <string>
#include <vector>

void lexicographical_sort(std::vector<int>& numbers) {
    std::vector<std::string> strings(numbers.size());
    std::transform(numbers.begin(), numbers.end(), strings.begin(),
                   [](int i) { return std::to_string(i); });
    std::sort(strings.begin(), strings.end());
    std::transform(strings.begin(), strings.end(), numbers.begin(),
                   [](const std::string& s) { return std::stoi(s); });
}

std::vector<int> lexicographically_sorted_vector(int n) {
    std::vector<int> numbers(n >= 1 ? n : 2 - n);
    std::iota(numbers.begin(), numbers.end(), std::min(1, n));
    lexicographical_sort(numbers);
    return numbers;
}

template <typename T>
void print_vector(std::ostream& out, const std::vector<T>& v) {
    out << '[';
    if (!v.empty()) {
        auto i = v.begin();
        out << *i++;
        for (; i != v.end(); ++i)
            out << ',' << *i;
    }
    out << "]\n";
}

int main(int argc, char** argv) {
    for (int i : { 0, 5, 13, 21, -22 }) {
        std::cout << i << ": ";
        print_vector(std::cout, lexicographically_sorted_vector(i));
    }
    return 0;
}
