#include <stdio.h>
#include <limits.h>

#define TRUE 1
#define FALSE 0
#define N_ROWS 5
#define N_COLS 5

typedef int bool;

int supply[N_ROWS] = { 461, 277, 356, 488,  393 };
int demand[N_COLS] = { 278,  60, 461, 116, 1060 };

int costs[N_ROWS][N_COLS] = {
    { 46,  74,  9, 28, 99 },
    { 12,  75,  6, 36, 48 },
    { 35, 199,  4,  5, 71 },
    { 61,  81, 44, 88,  9 },
    { 85,  60, 14, 25, 79 }
};

// etc

int main() {
    // etc

    printf("     A    B    C    D    E\n");
    for (i = 0; i < N_ROWS; ++i) {
        printf("%c", 'V' + i);
        for (j = 0; j < N_COLS; ++j) printf("  %3d", results[i][j]);
        printf("\n");
    }
    printf("\nTotal cost = %d\n", total_cost);
    return 0;
}
