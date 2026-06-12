#include <stdio.h>

int main() {
    for (int i = 0, sum = 0; i < 50; ++i) {
        sum += i * i * i;
        printf("%7d%c", sum, (i + 1) % 5 == 0 ? '\n' : ' ');
    }
    return 0;
}
