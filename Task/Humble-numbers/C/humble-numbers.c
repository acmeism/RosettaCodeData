#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

bool isHumble(int i) {
    if (i <= 1) return true;
    if (i % 2 == 0) return isHumble(i / 2);
    if (i % 3 == 0) return isHumble(i / 3);
    if (i % 5 == 0) return isHumble(i / 5);
    if (i % 7 == 0) return isHumble(i / 7);
    return false;
}

int main() {
    int limit = SHRT_MAX;
    int humble[16];
    int count = 0;
    int num = 1;
    char buffer[16];

    memset(humble, 0, sizeof(humble));

    for (; count < limit; num++) {
        if (isHumble(num)) {
            size_t len;
            sprintf_s(buffer, sizeof(buffer), "%d", num);
            len = strlen(buffer);
            if (len >= 16) {
                break;
            }
            humble[len]++;

            if (count < 50) {
                printf("%d ", num);
            }
            count++;
        }
    }
    printf("\n\n");

    printf("Of the first %d humble numbers:\n", count);
    for (num = 1; num < 10; num++) {
        printf("%5d have %d digits\n", humble[num], num);
    }

    return 0;
}
