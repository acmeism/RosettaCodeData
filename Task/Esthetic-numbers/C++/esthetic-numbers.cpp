#include <functional>
#include <iostream>
#include <sstream>
#include <vector>

std::string to(int n, int b) {
    static auto BASE = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";

    std::stringstream ss;
    while (n > 0) {
        auto rem = n % b;
        n = n / b;
        ss << BASE[rem];
    }

    auto fwd = ss.str();
    return std::string(fwd.rbegin(), fwd.rend());
}

uint64_t uabs(uint64_t a, uint64_t b) {
    if (a < b) {
        return b - a;
    }
    return a - b;
}

bool isEsthetic(uint64_t n, uint64_t b) {
    if (n == 0) {
        return false;
    }
    auto i = n % b;
    n /= b;
    while (n > 0) {
        auto j = n % b;
        if (uabs(i, j) != 1) {
            return false;
        }
        n /= b;
        i = j;
    }
    return true;
}

void listEsths(uint64_t n, uint64_t n2, uint64_t m, uint64_t m2, int perLine, bool all) {
    std::vector<uint64_t> esths;
    const auto dfs = [&esths](uint64_t n, uint64_t m, uint64_t i) {
        auto dfs_impl = [&esths](uint64_t n, uint64_t m, uint64_t i, auto &dfs_ref) {
            if (i >= n && i <= m) {
                esths.push_back(i);
            }
            if (i == 0 || i > m) {
                return;
            }
            auto d = i % 10;
            auto i1 = i * 10 + d - 1;
            auto i2 = i1 + 2;
            if (d == 0) {
                dfs_ref(n, m, i2, dfs_ref);
            } else if (d == 9) {
                dfs_ref(n, m, i1, dfs_ref);
            } else {
                dfs_ref(n, m, i1, dfs_ref);
                dfs_ref(n, m, i2, dfs_ref);
            }
        };
        dfs_impl(n, m, i, dfs_impl);
    };

    for (int i = 0; i < 10; i++) {
        dfs(n2, m2, i);
    }
    auto le = esths.size();
    printf("Base 10: %d esthetic numbers between %llu and %llu:\n", le, n, m);
    if (all) {
        for (size_t c = 0; c < esths.size(); c++) {
            auto esth = esths[c];
            printf("%llu ", esth);
            if ((c + 1) % perLine == 0) {
                printf("\n");
            }
        }
        printf("\n");
    } else {
        for (int c = 0; c < perLine; c++) {
            auto esth = esths[c];
            printf("%llu ", esth);
        }
        printf("\n............\n");
        for (size_t i = le - perLine; i < le; i++) {
            auto esth = esths[i];
            printf("%llu ", esth);
        }
        printf("\n");
    }
    printf("\n");
}

int main() {
    for (int b = 2; b <= 16; b++) {
        printf("Base %d: %dth to %dth esthetic numbers:\n", b, 4 * b, 6 * b);
        for (int n = 1, c = 0; c < 6 * b; n++) {
            if (isEsthetic(n, b)) {
                c++;
                if (c >= 4 * b) {
                    std::cout << to(n, b) << ' ';
                }
            }
        }
        printf("\n");
    }
    printf("\n");

    // the following all use the obvious range limitations for the numbers in question
    listEsths(1000, 1010, 9999, 9898, 16, true);
    listEsths((uint64_t)1e8, 101'010'101, 13 * (uint64_t)1e7, 123'456'789, 9, true);
    listEsths((uint64_t)1e11, 101'010'101'010, 13 * (uint64_t)1e10, 123'456'789'898, 7, false);
    listEsths((uint64_t)1e14, 101'010'101'010'101, 13 * (uint64_t)1e13, 123'456'789'898'989, 5, false);
    listEsths((uint64_t)1e17, 101'010'101'010'101'010, 13 * (uint64_t)1e16, 123'456'789'898'989'898, 4, false);
    return 0;
}
