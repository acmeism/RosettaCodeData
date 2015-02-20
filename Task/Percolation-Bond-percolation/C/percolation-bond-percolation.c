#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// cell states
#define FILL 1
#define RWALL 2 // right wall
#define BWALL 4 // bottom wall

typedef unsigned int c_t;

c_t *cells, *start, *end;
int m, n;

void make_grid(double p, int x, int y)
{
    int i, j, thresh = RAND_MAX * p;
    m = x, n = y;

    // Allocate two addition rows to avoid checking bounds.
    // Bottom row is also required by drippage
    start = realloc(start, m * (n + 2) * sizeof(c_t));
    cells = start + m;

    for (i = 0; i < m; i++)
        start[i] = BWALL | RWALL;

    for (i = 0, end = cells; i < y; i++) {
        for (j = x; --j; )
            *end++ = (rand() < thresh ? BWALL : 0)
                |(rand() < thresh ? RWALL : 0);
        *end++ = RWALL | (rand() < thresh ? BWALL: 0);
    }
    memset(end, 0, sizeof(c_t) * m);
}

void show_grid(void)
{
    int i, j;

    for (j = 0; j < m; j++) printf("+--");
    puts("+");

    for (i = 0; i <= n; i++) {
        putchar(i == n ? ' ' : '|');
        for (j = 0; j < m; j++) {
            printf((cells[i*m + j] & FILL) ? "[]" : "  ");
            putchar((cells[i*m + j] & RWALL) ? '|' : ' ');
        }
        putchar('\n');

        if (i == n) return;

        for (j = 0; j < m; j++)
            printf((cells[i*m + j] & BWALL) ? "+--" : "+  ");
        puts("+");
    }
}

int fill(c_t *p)
{
    if ((*p & FILL)) return 0;
    *p |= FILL;
    if (p >= end) return 1; // success: reached bottom row

    return  ( !(p[ 0] & BWALL) && fill(p + m) ) ||
        ( !(p[ 0] & RWALL) && fill(p + 1) ) ||
        ( !(p[-1] & RWALL) && fill(p - 1) ) ||
        ( !(p[-m] & BWALL) && fill(p - m) );
}

int percolate(void)
{
    int i;
    for (i = 0; i < m && !fill(cells + i); i++);

    return i < m;
}

int main(void)
{
    make_grid(.5, 10, 10);
    percolate();
    show_grid();

    int cnt, i, p;

    puts("\nrunning 10x10 grids 10000 times for each p:");
    for (p = 1; p < 10; p++) {
        for (cnt = i = 0; i < 10000; i++) {
            make_grid(p / 10., 10, 10);
            cnt += percolate();
            //show_grid(); // don't
        }
        printf("p = %3g: %.4f\n", p / 10., (double)cnt / i);
    }

    free(start);
    return 0;
}
