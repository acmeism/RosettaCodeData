#include <stdio.h>

#define N 32
#define K 3
#define MAX N * K

typedef struct { int x; int y; } point;

void rot(int n, point *p, int rx, int ry) {
    int t;
    if (!ry) {
        if (rx == 1) {
            p->x = n - 1 - p->x;
            p->y = n - 1 - p->y;
        }
        t = p->x;
        p->x = p->y;
        p->y = t;
    }
}

void d2pt(int n, int d, point *p) {
    int s = 1, t = d, rx, ry;
    p->x = 0;
    p->y = 0;
    while (s < n) {
        rx = 1 & (t / 2);
        ry = 1 & (t ^ rx);
        rot(s, p, rx, ry);
        p->x += s * rx;
        p->y += s * ry;
        t /= 4;
        s *= 2;
    }
}

int main() {
    int d, x, y, cx, cy, px, py;
    char pts[MAX][MAX];
    point curr, prev;
    for (x = 0; x < MAX; ++x)
        for (y = 0; y < MAX; ++y) pts[x][y] = ' ';
    prev.x = prev.y = 0;
    pts[0][0] = '.';
    for (d = 1; d < N * N; ++d) {
        d2pt(N, d, &curr);
        cx = curr.x * K;
        cy = curr.y * K;
        px = prev.x * K;
        py = prev.y * K;
        pts[cx][cy] = '.';
        if (cx == px ) {
            if (py < cy)
                for (y = py + 1; y < cy; ++y) pts[cx][y] = '|';
            else
                for (y = cy + 1; y < py; ++y) pts[cx][y] = '|';
        }
        else {
            if (px < cx)
                for (x = px + 1; x < cx; ++x) pts[x][cy] = '_';
            else
                for (x = cx + 1; x < px; ++x) pts[x][cy] = '_';
        }
        prev = curr;
    }
    for (x = 0; x < MAX; ++x) {
        for (y = 0; y < MAX; ++y) printf("%c", pts[y][x]);
        printf("\n");
    }
    return 0;
}
