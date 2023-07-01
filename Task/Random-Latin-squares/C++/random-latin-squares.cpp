#include <algorithm>
#include <chrono>
#include <iostream>
#include <random>
#include <vector>

template <typename T>
std::ostream &operator<<(std::ostream &os, const std::vector<T> &v) {
    auto it = v.cbegin();
    auto end = v.cend();

    os << '[';
    if (it != end) {
        os << *it;
        it = std::next(it);
    }
    while (it != end) {
        os << ", ";
        os << *it;
        it = std::next(it);
    }
    return os << ']';
}

void printSquare(const std::vector<std::vector<int>> &latin) {
    for (auto &row : latin) {
        std::cout << row << '\n';
    }
    std::cout << '\n';
}

void latinSquare(int n) {
    if (n <= 0) {
        std::cout << "[]\n";
        return;
    }

    // obtain a time-based seed:
    unsigned seed = std::chrono::system_clock::now().time_since_epoch().count();
    auto g = std::default_random_engine(seed);

    std::vector<std::vector<int>> latin;
    for (int i = 0; i < n; ++i) {
        std::vector<int> inner;
        for (int j = 0; j < n; ++j) {
            inner.push_back(j);
        }
        latin.push_back(inner);
    }
    // first row
    std::shuffle(latin[0].begin(), latin[0].end(), g);

    // middle row(s)
    for (int i = 1; i < n - 1; ++i) {
        bool shuffled = false;

        while (!shuffled) {
            std::shuffle(latin[i].begin(), latin[i].end(), g);
            for (int k = 0; k < i; ++k) {
                for (int j = 0; j < n; ++j) {
                    if (latin[k][j] == latin[i][j]) {
                        goto shuffling;
                    }
                }
            }
            shuffled = true;

        shuffling: {}
        }
    }

    // last row
    for (int j = 0; j < n; ++j) {
        std::vector<bool> used(n, false);
        for (int i = 0; i < n - 1; ++i) {
            used[latin[i][j]] = true;
        }
        for (int k = 0; k < n; ++k) {
            if (!used[k]) {
                latin[n - 1][j] = k;
                break;
            }
        }
    }

    printSquare(latin);
}

int main() {
    latinSquare(5);
    latinSquare(5);
    latinSquare(10);
    return 0;
}
