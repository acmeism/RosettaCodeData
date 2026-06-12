#include <stdio.h>
#include <stdlib.h>
#define ROWS 15
int main() {
        unsigned int* row = malloc(ROWS*sizeof(unsigned int));
        unsigned int* prevrow = malloc(ROWS*sizeof(unsigned int));
        unsigned int* tmp;
        prevrow[0] = 1;
        for (int i = 0; i < ROWS; ++i) {
                row[i] = 1 << i;
                for (int j = 1; j < i; ++j) row[j] = prevrow[j] + prevrow[j-1];
                for (int j = 0; j < i; ++j) printf("%u ", row[j]);
                printf("%u\n", row[i]);
                tmp = prevrow;
                prevrow = row;
                row = tmp;
        }
        free(row);
        free(prevrow);
        return(0);
}
