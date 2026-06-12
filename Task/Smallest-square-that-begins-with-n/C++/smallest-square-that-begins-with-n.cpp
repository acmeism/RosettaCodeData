#include <iostream>

void f(int n) {
    if (n < 1) {
        return;
    }

    int i = 1;
    while (true) {
        int sq = i * i;
        while (sq > n) {
            sq /= 10;
        }
        if (sq == n) {
            printf("%3d %9d %4d\n", n, i * i, i);
            return;
        }
        i++;
    }
}

int main() {
    std::cout << "Prefix    n^2    n\n";
    for (int i = 0; i < 50; i++) {
        f(i);
    }

    return 0;
}
