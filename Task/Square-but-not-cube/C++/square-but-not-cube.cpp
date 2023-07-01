#include <iostream>
#include <cmath>

int main() {
    int n = 1;
    int count = 0;
    int sq;
    int cr;

    for (; count < 30; ++n) {
        sq = n * n;
        cr = cbrt(sq);
        if (cr * cr * cr != sq) {
            count++;
            std::cout << sq << '\n';
        } else {
            std::cout << sq << " is square and cube\n";
        }
    }

    return 0;
}
