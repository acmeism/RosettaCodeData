#include <algorithm>
#include <functional>
#include <iostream>
#include <numeric>
#include <vector>

typedef std::vector<std::vector<int>> matrix;

matrix dList(int n, int start) {
    start--; // use 0 basing

    std::vector<int> a(n);
    std::iota(a.begin(), a.end(), 0);
    a[start] = a[0];
    a[0] = start;
    std::sort(a.begin() + 1, a.end());
    auto first = a[1];
    // recursive closure permutes a[1:]
    matrix r;
    std::function<void(int)> recurse;
    recurse = [&](int last) {
        if (last == first) {
            // bottom of recursion you get here once for each permutation.
            // test if permutation is deranged.
            for (size_t j = 1; j < a.size(); j++) {
                auto v = a[j];
                if (j == v) {
                    return; //no, ignore it
                }
            }
            // yes, save a copy with 1 based indexing
            std::vector<int> b;
            std::transform(a.cbegin(), a.cend(), std::back_inserter(b), [](int v) { return v + 1; });
            r.push_back(b);
            return;
        }
        for (int i = last; i >= 1; i--) {
            std::swap(a[i], a[last]);
            recurse(last - 1);
            std::swap(a[i], a[last]);
        }
    };
    recurse(n - 1);
    return r;
}

void printSquare(const matrix &latin, int n) {
    for (auto &row : latin) {
        auto it = row.cbegin();
        auto end = row.cend();
        std::cout << '[';
        if (it != end) {
            std::cout << *it;
            it = std::next(it);
        }
        while (it != end) {
            std::cout << ", " << *it;
            it = std::next(it);
        }
        std::cout << "]\n";
    }
    std::cout << '\n';
}

unsigned long reducedLatinSquares(int n, bool echo) {
    if (n <= 0) {
        if (echo) {
            std::cout << "[]\n";
        }
        return 0;
    } else if (n == 1) {
        if (echo) {
            std::cout << "[1]\n";
        }
        return 1;
    }

    matrix rlatin;
    for (int i = 0; i < n; i++) {
        rlatin.push_back({});
        for (int j = 0; j < n; j++) {
            rlatin[i].push_back(j);
        }
    }
    // first row
    for (int j = 0; j < n; j++) {
        rlatin[0][j] = j + 1;
    }

    unsigned long count = 0;
    std::function<void(int)> recurse;
    recurse = [&](int i) {
        auto rows = dList(n, i);

        for (size_t r = 0; r < rows.size(); r++) {
            rlatin[i - 1] = rows[r];
            for (int k = 0; k < i - 1; k++) {
                for (int j = 1; j < n; j++) {
                    if (rlatin[k][j] == rlatin[i - 1][j]) {
                        if (r < rows.size() - 1) {
                            goto outer;
                        }
                        if (i > 2) {
                            return;
                        }
                    }
                }
            }
            if (i < n) {
                recurse(i + 1);
            } else {
                count++;
                if (echo) {
                    printSquare(rlatin, n);
                }
            }
        outer: {}
        }
    };

    //remaining rows
    recurse(2);
    return count;
}

unsigned long factorial(unsigned long n) {
    if (n <= 0) return 1;
    unsigned long prod = 1;
    for (unsigned long i = 2; i <= n; i++) {
        prod *= i;
    }
    return prod;
}

int main() {
    std::cout << "The four reduced lating squares of order 4 are:\n";
    reducedLatinSquares(4, true);

    std::cout << "The size of the set of reduced latin squares for the following orders\n";
    std::cout << "and hence the total number of latin squares of these orders are:\n\n";
    for (int n = 1; n < 7; n++) {
        auto size = reducedLatinSquares(n, false);
        auto f = factorial(n - 1);
        f *= f * n * size;
        std::cout << "Order " << n << ": Size " << size << " x " << n << "! x " << (n - 1) << "! => Total " << f << '\n';
    }

    return 0;
}
