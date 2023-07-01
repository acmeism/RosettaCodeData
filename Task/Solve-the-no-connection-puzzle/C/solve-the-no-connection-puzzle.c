#include <stdbool.h>
#include <stdio.h>
#include <math.h>

int connections[15][2] = {
    {0, 2}, {0, 3}, {0, 4}, // A to C,D,E
    {1, 3}, {1, 4}, {1, 5}, // B to D,E,F
    {6, 2}, {6, 3}, {6, 4}, // G to C,D,E
    {7, 3}, {7, 4}, {7, 5}, // H to D,E,F
    {2, 3}, {3, 4}, {4, 5}, // C-D, D-E, E-F
};

int pegs[8];
int num = 0;

bool valid() {
    int i;
    for (i = 0; i < 15; i++) {
        if (abs(pegs[connections[i][0]] - pegs[connections[i][1]]) == 1) {
            return false;
        }
    }
    return true;
}

void swap(int *a, int *b) {
    int t = *a;
    *a = *b;
    *b = t;
}

void printSolution() {
    printf("----- %d -----\n", num++);
    printf("  %d %d\n", /*        */ pegs[0], pegs[1]);
    printf("%d %d %d %d\n", pegs[2], pegs[3], pegs[4], pegs[5]);
    printf("  %d %d\n", /*        */ pegs[6], pegs[7]);
    printf("\n");
}

void solution(int le, int ri) {
    if (le == ri) {
        if (valid()) {
            printSolution();
        }
    } else {
        int i;
        for (i = le; i <= ri; i++) {
            swap(pegs + le, pegs + i);
            solution(le + 1, ri);
            swap(pegs + le, pegs + i);
        }
    }
}

int main() {
    int i;
    for (i = 0; i < 8; i++) {
        pegs[i] = i + 1;
    }

    solution(0, 8 - 1);
    return 0;
}
