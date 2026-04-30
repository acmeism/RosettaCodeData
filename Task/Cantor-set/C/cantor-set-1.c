#include <stdio.h>

#define WIDTH 81
#define HEIGHT 5

char lines[HEIGHT][WIDTH];

void init() {
    int i, j;
    for (i = 0; i < HEIGHT; ++i) {
        for (j = 0; j < WIDTH; ++j) lines[i][j] = '*';
    }
}

void cantor(int start, int len, int index) {
    int i, j, seg = len / 3;
    if (seg == 0) return;
    for (i = index; i < HEIGHT; ++i) {
        for (j = start + seg; j < start + seg * 2; ++j) lines[i][j] = ' ';
    }
    cantor(start, seg, index + 1);
    cantor(start + seg * 2, seg, index + 1);
}

void print() {
    int i, j;
    for (i = 0; i < HEIGHT; ++i) {
        for (j = 0; j < WIDTH; ++j) printf("%c", lines[i][j]);
        printf("\n");
    }
}

int main() {
    init();
    cantor(0, WIDTH, 1);
    print();
    return 0;
}
