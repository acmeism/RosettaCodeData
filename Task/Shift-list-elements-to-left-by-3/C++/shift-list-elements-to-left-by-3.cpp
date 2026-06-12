#include <algorithm>
#include <iostream>
#include <iterator>
#include <vector>

template <typename T>
void print(const std::vector<T>& v) {
    std::copy(v.begin(), v.end(), std::ostream_iterator<T>(std::cout, " "));
    std::cout << '\n';
}

int main() {
    std::vector<int> vec{1, 2, 3, 4, 5, 6, 7, 8, 9};
    std::cout << "Before: ";
    print(vec);
    std::rotate(vec.begin(), vec.begin() + 3, vec.end());
    std::cout << " After: ";
    print(vec);
}
