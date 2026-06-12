#include <algorithm>
#include <iostream>
#include <numeric>
#include <sstream>
#include <vector>

// Returns true if any subset of [begin, end) sums to n.
template <typename iterator>
bool sum_of_any_subset(int n, iterator begin, iterator end) {
    if (begin == end)
        return false;
    if (std::find(begin, end, n) != end)
        return true;
    int total = std::accumulate(begin, end, 0);
    if (n == total)
        return true;
    if (n > total)
        return false;
    --end;
    int d = n - *end;
    return (d > 0 && sum_of_any_subset(d, begin, end)) ||
           sum_of_any_subset(n, begin, end);
}

// Returns the proper divisors of n.
std::vector<int> factors(int n) {
    std::vector<int> f{1};
    for (int i = 2; i * i <= n; ++i) {
        if (n % i == 0) {
            f.push_back(i);
            if (i * i != n)
                f.push_back(n / i);
        }
    }
    std::sort(f.begin(), f.end());
    return f;
}

bool is_practical(int n) {
    std::vector<int> f = factors(n);
    for (int i = 1; i < n; ++i) {
        if (!sum_of_any_subset(i, f.begin(), f.end()))
            return false;
    }
    return true;
}

std::string shorten(const std::vector<int>& v, size_t n) {
    std::ostringstream out;
    size_t size = v.size(), i = 0;
    if (n > 0 && size > 0)
        out << v[i++];
    for (; i < n && i < size; ++i)
        out << ", " << v[i];
    if (size > i + n) {
        out << ", ...";
        i = size - n;
    }
    for (; i < size; ++i)
        out << ", " << v[i];
    return out.str();
}

int main() {
    std::vector<int> practical;
    for (int n = 1; n <= 333; ++n) {
        if (is_practical(n))
            practical.push_back(n);
    }
    std::cout << "Found " << practical.size() << " practical numbers:\n"
              << shorten(practical, 10) << '\n';
    for (int n : {666, 6666, 66666, 672, 720, 222222})
        std::cout << n << " is " << (is_practical(n) ? "" : "not ")
                  << "a practical number.\n";
    return 0;
}
