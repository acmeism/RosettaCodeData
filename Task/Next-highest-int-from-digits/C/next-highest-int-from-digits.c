#include <stdbool.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

void swap(char* str, int i, int j) {
    char c = str[i];
    str[i] = str[j];
    str[j] = c;
}

void reverse(char* str, int i, int j) {
    for (; i < j; ++i, --j)
        swap(str, i, j);
}

bool next_permutation(char* str) {
    int len = strlen(str);
    if (len < 2)
        return false;
    for (int i = len - 1; i > 0; ) {
        int j = i, k;
        if (str[--i] < str[j]) {
            k = len;
            while (str[i] >= str[--k]) {}
            swap(str, i, k);
            reverse(str, j, len - 1);
            return true;
        }
    }
    return false;
}

uint32_t next_highest_int(uint32_t n) {
    char str[16];
    snprintf(str, sizeof(str), "%u", n);
    if (!next_permutation(str))
        return 0;
    return strtoul(str, 0, 10);
}

int main() {
    uint32_t numbers[] = {0, 9, 12, 21, 12453, 738440, 45072010, 95322020};
    const int count = sizeof(numbers)/sizeof(int);
    for (int i = 0; i < count; ++i)
        printf("%d -> %d\n", numbers[i], next_highest_int(numbers[i]));
    // Last one is too large to convert to an integer
    const char big[] = "9589776899767587796600";
    char next[sizeof(big)];
    memcpy(next, big, sizeof(big));
    next_permutation(next);
    printf("%s -> %s\n", big, next);
    return 0;
}
