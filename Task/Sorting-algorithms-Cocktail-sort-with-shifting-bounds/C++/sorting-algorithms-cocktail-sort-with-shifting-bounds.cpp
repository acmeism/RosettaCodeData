#include <algorithm>
#include <cassert>
#include <iostream>
#include <iterator>
#include <vector>

// This only works for random access iterators
template <typename iterator>
void cocktail_shaker_sort(iterator begin, iterator end) {
    if (begin == end)
        return;
    for (--end; begin < end; ) {
        iterator new_begin = end;
        iterator new_end = begin;
        for (iterator i = begin; i < end; ++i) {
            iterator j = i + 1;
            if (*j < *i) {
                std::iter_swap(i, j);
                new_end = i;
            }
        }
        end = new_end;
        for (iterator i = end; i > begin; --i) {
            iterator j = i - 1;
            if (*i < *j) {
                std::iter_swap(i, j);
                new_begin = i;
            }
        }
        begin = new_begin;
    }
}

template <typename iterator>
void print(iterator begin, iterator end) {
    if (begin == end)
        return;
    std::cout << *begin++;
    while (begin != end)
        std::cout << ' ' << *begin++;
    std::cout << '\n';
}

int main() {
    std::vector<int> v{5, 1, -6, 12, 3, 13, 2, 4, 0, 15};
    std::cout << "before: ";
    print(v.begin(), v.end());
    cocktail_shaker_sort(v.begin(), v.end());
    assert(std::is_sorted(v.begin(), v.end()));
    std::cout << "after: ";
    print(v.begin(), v.end());
    return 0;
}
