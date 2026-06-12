#include <cstdint>
#include <functional>
#include <iomanip>
#include <iostream>

// highest power of 2 that divides a given number
uint32_t hpo2(uint32_t n) {
    return n & -n;
}

// base 2 logarithm of the highest power of 2 dividing a given number
uint32_t lhpo2(uint32_t n) {
    uint32_t q = 0, m = hpo2(n);
    for (; m % 2 == 0; m >>= 1, ++q) {}
    return q;
}

// nim-sum of two numbers
uint32_t nimsum(uint32_t x, uint32_t y) {
    return x ^ y;
}

// nim-product of two numbers
uint32_t nimprod(uint32_t x, uint32_t y) {
    if (x < 2 || y < 2)
        return x * y;
    uint32_t h = hpo2(x);
    if (x > h)
        return nimprod(h, y) ^ nimprod(x ^ h, y);
    if (hpo2(y) < y)
        return nimprod(y, x);
    uint32_t xp = lhpo2(x), yp = lhpo2(y);
    uint32_t comp = xp & yp;
    if (comp == 0)
        return x * y;
    h = hpo2(comp);
    return nimprod(nimprod(x >> h, y >> h), 3 << (h - 1));
}

void print_table(uint32_t n, char op, std::function<uint32_t(uint32_t, uint32_t)> func) {
    std::cout << ' ' << op << " |";
    for (uint32_t a = 0; a <= n; ++a)
        std::cout << std::setw(3) << a;
    std::cout << "\n--- -";
    for (uint32_t a = 0; a <= n; ++a)
        std::cout << "---";
    std::cout << '\n';
    for (uint32_t b = 0; b <= n; ++b) {
        std::cout << std::setw(2) << b << " |";
        for (uint32_t a = 0; a <= n; ++a)
            std::cout << std::setw(3) << func(a, b);
        std::cout << '\n';
    }
}

int main() {
    print_table(15, '+', nimsum);
    printf("\n");
    print_table(15, '*', nimprod);
    const uint32_t a = 21508, b = 42689;
    std::cout << '\n';
    std::cout << a << " + " << b << " = " << nimsum(a, b) << '\n';
    std::cout << a << " * " << b << " = " << nimprod(a, b) << '\n';
    return 0;
}
