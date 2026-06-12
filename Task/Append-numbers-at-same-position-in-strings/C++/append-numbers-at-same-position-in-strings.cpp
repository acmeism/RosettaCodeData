#include <iostream>

int main() {
    int list[3][9], i;
    for (i = 0; i < 27; i++) {
        list[i / 9][i % 9] = 1 + i;
    }
    for (i = 0; i < 9; i++) {
        std::cout << list[0][i] << list[1][i] << list[2][i] << "  ";
    }
    return 0;
}
