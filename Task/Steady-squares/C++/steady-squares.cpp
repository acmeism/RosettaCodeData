#include <iostream>
using namespace std;

bool steady(int n) {
    int mask = 1;
    for (int d = n; d != 0; d /= 10)
        mask *= 10;
    return (n * n) % mask == n;
}

int main() {
    for (int i = 1; i < 10000; i++)
        if (steady(i)) printf("%4d^2 = %8d\n", i, i * i);
}
