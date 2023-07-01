#include <iostream>

bool valid(int n, int nuts) {
    for (int k = n; k != 0; k--, nuts -= 1 + nuts / n) {
        if (nuts % n != 1) {
            return false;
        }
    }

    return nuts != 0 && (nuts % n == 0);
}

int main() {
    int x = 0;
    for (int n = 2; n < 10; n++) {
        while (!valid(n, x)) {
            x++;
        }
        std::cout << n << ": " << x << std::endl;
    }

    return 0;
}
