#include <stdlib.h>

#define N 26

int main() {
    unsigned char lower[N];

    for (size_t i = 0; i < N; i++) {
        lower[i] = i + 'a';
    }

    return EXIT_SUCCESS;
}
