#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// to supply to qsort
int compare(const void *a, const void *b) {
    int int_a = *((int *)a);
    int int_b = *((int *)b);
    return (int_a > int_b) - (int_a < int_b);
}

char results[7];
bool next_result() {
    char *ptr = results + 5;
    int num = 0;
    size_t i;

    // check if the space has been examined
    if (strcmp(results, "222222") == 0) {
        return false;
    }

    // translate the base 3 string back to a base 10 integer
    for (i = 0; results[i] != 0; i++) {
        int d = results[i] - '0';
        num = 3 * num + d;
    }

    // to the next value to process
    num++;

    // write the base 3 string (fixed width)
    while (num > 0) {
        int rem = num % 3;
        num /= 3;
        *ptr-- = rem + '0';
    }
    // zero fill the remainder
    while (ptr > results) {
        *ptr-- = '0';
    }

    return true;
}

char *games[6] = { "12", "13", "14", "23", "24", "34" };
char *places[4] = { "1st", "2nd", "3rd", "4th" };
int main() {
    int points[4][10];
    size_t i, j;

    strcpy(results, "000000");
    for (i = 0; i < 4; i++) {
        for (j = 0; j < 10; j++) {
            points[i][j] = 0;
        }
    }

    do {
        int records[] = { 0, 0, 0, 0 };

        for (i = 0; i < 6; i++) {
            switch (results[i]) {
            case '2':
                records[games[i][0] - '1'] += 3;
                break;
            case '1':
                records[games[i][0] - '1']++;
                records[games[i][1] - '1']++;
                break;
            case '0':
                records[games[i][1] - '1'] += 3;
                break;
            default:
                break;
            }
        }

        qsort(records, 4, sizeof(int), compare);
        for (i = 0; i < 4; i++) {
            points[i][records[i]]++;
        }
    } while (next_result());

    printf("POINTS       0    1    2    3    4    5    6    7    8    9\n");
    printf("-----------------------------------------------------------\n");
    for (i = 0; i < 4; i++) {
        printf("%s place", places[i]);
        for (j = 0; j < 10; j++) {
            printf("%5d", points[3 - i][j]);
        }
        printf("\n");
    }

    return 0;
}
