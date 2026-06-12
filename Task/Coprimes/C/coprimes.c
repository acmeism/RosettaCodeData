#include <stdio.h>

int gcd(int a, int b) {
    int c;
    while (b) {
        c = a;
        a = b;
        b = c % b;
    }
    return a;
}

struct pair {
    int x, y;
};

void printPair(struct pair const *p) {
    printf("{%d, %d}\n", p->x, p->y);
}

int main() {
    struct pair pairs[] = {
        {21,15}, {17,23}, {36,12}, {18,29}, {60,15}
    };

    int i;
    for (i=0; i<5; i++) {
        if (gcd(pairs[i].x, pairs[i].y) == 1)
            printPair(&pairs[i]);
    }
    return 0;
}
