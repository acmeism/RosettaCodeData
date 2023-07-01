#include <algorithm>
#include <cassert>
#include <iomanip>
#include <iostream>

int jacobi(int n, int k) {
    assert(k > 0 && k % 2 == 1);
    n %= k;
    int t = 1;
    while (n != 0) {
        while (n % 2 == 0) {
            n /= 2;
            int r = k % 8;
            if (r == 3 || r == 5)
                t = -t;
        }
        std::swap(n, k);
        if (n % 4 == 3 && k % 4 == 3)
            t = -t;
        n %= k;
    }
    return k == 1 ? t : 0;
}

void print_table(std::ostream& out, int kmax, int nmax) {
    out << "n\\k|";
    for (int k = 0; k <= kmax; ++k)
        out << ' ' << std::setw(2) << k;
    out << "\n----";
    for (int k = 0; k <= kmax; ++k)
        out << "---";
    out << '\n';
    for (int n = 1; n <= nmax; n += 2) {
        out << std::setw(2) << n << " |";
        for (int k = 0; k <= kmax; ++k)
            out << ' ' << std::setw(2) << jacobi(k, n);
        out << '\n';
    }
}

int main() {
    print_table(std::cout, 20, 21);
    return 0;
}
