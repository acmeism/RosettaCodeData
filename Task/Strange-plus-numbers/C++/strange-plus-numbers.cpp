#include <iostream>
#include <vector>

const std::vector<bool> p{
    false, false, true,  true,  false,
    true,  false, true,  false, false,
    false, true,  false, true,  false,
    false, false, true,  false
};

bool isStrange(long n) {
    if (n < 10) {
        return false;
    }
    for (; n >= 10; n /= 10) {
        if (!p[n % 10 + (n / 10) % 10]) {
            return false;
        }
    }
    return true;
}

void test(int nMin, int nMax) {
    int k = 0;

    for (long n = nMin; n <= nMax;n++) {
        if (isStrange(n)) {
            std::cout << n;
            if (++k % 10 != 0) {
                std::cout << ' ';
            } else {
                std::cout << '\n';
            }
        }
    }
}

int main() {
    test(101, 499);
    return 0;
}
