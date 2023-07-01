#include <algorithm>
#include <iostream>
#include <utility>
#include <vector>

// A range is represented as std::pair<from, to>

template <typename iterator>
void normalize_ranges(iterator begin, iterator end) {
    for (iterator i = begin; i != end; ++i) {
        if (i->second < i->first)
            std::swap(i->first, i->second);
    }
    std::sort(begin, end);
}

// Merges a range of ranges in-place. Returns an iterator to the
// end of the resulting range, similarly to std::remove.
template <typename iterator>
iterator merge_ranges(iterator begin, iterator end) {
    iterator out = begin;
    for (iterator i = begin; i != end; ) {
        iterator j = i;
        while (++j != end && j->first <= i->second)
            i->second = std::max(i->second, j->second);
        *out++ = *i;
        i = j;
    }
    return out;
}

template <typename iterator>
iterator consolidate_ranges(iterator begin, iterator end) {
    normalize_ranges(begin, end);
    return merge_ranges(begin, end);
}

template <typename pair>
void print_range(std::ostream& out, const pair& range) {
    out << '[' << range.first << ", " << range.second << ']';
}

template <typename iterator>
void print_ranges(std::ostream& out, iterator begin, iterator end) {
    if (begin != end) {
        print_range(out, *begin++);
        for (; begin != end; ++begin) {
            out << ", ";
            print_range(out, *begin);
        }
    }
}

int main() {
    std::vector<std::pair<double, double>> test_cases[] = {
        { {1.1, 2.2} },
        { {6.1, 7.2}, {7.2, 8.3} },
        { {4, 3}, {2, 1} },
        { {4, 3}, {2, 1}, {-1, -2}, {3.9, 10} },
        { {1, 3}, {-6, -1}, {-4, -5}, {8, 2}, {-6, -6} }
    };
    for (auto&& ranges : test_cases) {
        print_ranges(std::cout, std::begin(ranges), std::end(ranges));
        std::cout << " -> ";
        auto i = consolidate_ranges(std::begin(ranges), std::end(ranges));
        print_ranges(std::cout, std::begin(ranges), i);
        std::cout << '\n';
    }
    return 0;
}
