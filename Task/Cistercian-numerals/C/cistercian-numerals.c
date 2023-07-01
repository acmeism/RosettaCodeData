#include <stdio.h>

#define GRID_SIZE 15
char canvas[GRID_SIZE][GRID_SIZE];

void initN() {
    int i, j;
    for (i = 0; i < GRID_SIZE; i++) {
        for (j = 0; j < GRID_SIZE; j++) {
            canvas[i][j] = ' ';
        }
        canvas[i][5] = 'x';
    }
}

void horizontal(size_t c1, size_t c2, size_t r) {
    size_t c;
    for (c = c1; c <= c2; c++) {
        canvas[r][c] = 'x';
    }
}

void vertical(size_t r1, size_t r2, size_t c) {
    size_t r;
    for (r = r1; r <= r2; r++) {
        canvas[r][c] = 'x';
    }
}

void diagd(size_t c1, size_t c2, size_t r) {
    size_t c;
    for (c = c1; c <= c2; c++) {
        canvas[r + c - c1][c] = 'x';
    }
}

void diagu(size_t c1, size_t c2, size_t r) {
    size_t c;
    for (c = c1; c <= c2; c++) {
        canvas[r - c + c1][c] = 'x';
    }
}

void drawOnes(int v) {
    switch (v) {
    case 1:
        horizontal(6, 10, 0);
        break;
    case 2:
        horizontal(6, 10, 4);
        break;
    case 3:
        diagd(6, 10, 0);
        break;
    case 4:
        diagu(6, 10, 4);
        break;
    case 5:
        drawOnes(1);
        drawOnes(4);
        break;
    case 6:
        vertical(0, 4, 10);
        break;
    case 7:
        drawOnes(1);
        drawOnes(6);
        break;
    case 8:
        drawOnes(2);
        drawOnes(6);
        break;
    case 9:
        drawOnes(1);
        drawOnes(8);
        break;
    default:
        break;
    }
}

void drawTens(int v) {
    switch (v) {
    case 1:
        horizontal(0, 4, 0);
        break;
    case 2:
        horizontal(0, 4, 4);
        break;
    case 3:
        diagu(0, 4, 4);
        break;
    case 4:
        diagd(0, 4, 0);
        break;
    case 5:
        drawTens(1);
        drawTens(4);
        break;
    case 6:
        vertical(0, 4, 0);
        break;
    case 7:
        drawTens(1);
        drawTens(6);
        break;
    case 8:
        drawTens(2);
        drawTens(6);
        break;
    case 9:
        drawTens(1);
        drawTens(8);
        break;
    default:
        break;
    }
}

void drawHundreds(int hundreds) {
    switch (hundreds) {
    case 1:
        horizontal(6, 10, 14);
        break;
    case 2:
        horizontal(6, 10, 10);
        break;
    case 3:
        diagu(6, 10, 14);
        break;
    case 4:
        diagd(6, 10, 10);
        break;
    case 5:
        drawHundreds(1);
        drawHundreds(4);
        break;
    case 6:
        vertical(10, 14, 10);
        break;
    case 7:
        drawHundreds(1);
        drawHundreds(6);
        break;
    case 8:
        drawHundreds(2);
        drawHundreds(6);
        break;
    case 9:
        drawHundreds(1);
        drawHundreds(8);
        break;
    default:
        break;
    }
}

void drawThousands(int thousands) {
    switch (thousands) {
    case 1:
        horizontal(0, 4, 14);
        break;
    case 2:
        horizontal(0, 4, 10);
        break;
    case 3:
        diagd(0, 4, 10);
        break;
    case 4:
        diagu(0, 4, 14);
        break;
    case 5:
        drawThousands(1);
        drawThousands(4);
        break;
    case 6:
        vertical(10, 14, 0);
        break;
    case 7:
        drawThousands(1);
        drawThousands(6);
        break;
    case 8:
        drawThousands(2);
        drawThousands(6);
        break;
    case 9:
        drawThousands(1);
        drawThousands(8);
        break;
    default:
        break;
    }
}

void draw(int v) {
    int thousands = v / 1000;
    v %= 1000;

    int hundreds = v / 100;
    v %= 100;

    int tens = v / 10;
    int ones = v % 10;

    if (thousands > 0) {
        drawThousands(thousands);
    }
    if (hundreds > 0) {
        drawHundreds(hundreds);
    }
    if (tens > 0) {
        drawTens(tens);
    }
    if (ones > 0) {
        drawOnes(ones);
    }
}

void write(FILE *out) {
    int i;
    for (i = 0; i < GRID_SIZE; i++) {
        fprintf(out, "%-.*s", GRID_SIZE, canvas[i]);
        putc('\n', out);
    }
}

void test(int n) {
    printf("%d:\n", n);
    initN();
    draw(n);
    write(stdout);
    printf("\n\n");
}

int main() {
    test(0);
    test(1);
    test(20);
    test(300);
    test(4000);
    test(5555);
    test(6789);
    test(9999);

    return 0;
}
