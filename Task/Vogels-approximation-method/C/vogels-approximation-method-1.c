#include <stdio.h>
#include <limits.h>

#define TRUE 1
#define FALSE 0
#define N_ROWS 4
#define N_COLS 5

typedef int bool;

int supply[N_ROWS] = { 50, 60, 50, 50 };
int demand[N_COLS] = { 30, 20, 70, 30, 60 };

int costs[N_ROWS][N_COLS] = {
    { 16, 16, 13, 22, 17 },
    { 14, 14, 13, 19, 15 },
    { 19, 19, 20, 23, 50 },
    { 50, 12, 50, 15, 11 }
};

bool row_done[N_ROWS] = { FALSE };
bool col_done[N_COLS] = { FALSE };

void diff(int j, int len, bool is_row, int res[3]) {
    int i, c, min1 = INT_MAX, min2 = min1, min_p = -1;
    for (i = 0; i < len; ++i) {
        if((is_row) ? col_done[i] : row_done[i]) continue;
        c = (is_row) ? costs[j][i] : costs[i][j];
        if (c < min1) {
            min2 = min1;
            min1 = c;
            min_p = i;
        }
        else if (c < min2) min2 = c;
    }
    res[0] = min2 - min1; res[1] = min1; res[2] = min_p;
}

void max_penalty(int len1, int len2, bool is_row, int res[4]) {
    int i, pc = -1, pm = -1, mc = -1, md = INT_MIN;
    int res2[3];

    for (i = 0; i < len1; ++i) {
        if((is_row) ? row_done[i] : col_done[i]) continue;
        diff(i, len2, is_row, res2);
        if (res2[0] > md) {
            md = res2[0];  /* max diff */
            pm = i;        /* pos of max diff */
            mc = res2[1];  /* min cost */
            pc = res2[2];  /* pos of min cost */
        }
    }

    if (is_row) {
        res[0] = pm; res[1] = pc;
    }
    else {
        res[0] = pc; res[1] = pm;
    }
    res[2] = mc; res[3] = md;
}

void next_cell(int res[4]) {
    int i, res1[4], res2[4];
    max_penalty(N_ROWS, N_COLS, TRUE, res1);
    max_penalty(N_COLS, N_ROWS, FALSE, res2);

    if (res1[3] == res2[3]) {
        if (res1[2] < res2[2])
            for (i = 0; i < 4; ++i) res[i] = res1[i];
        else
            for (i = 0; i < 4; ++i) res[i] = res2[i];
        return;
    }
    if (res1[3] > res2[3])
        for (i = 0; i < 4; ++i) res[i] = res2[i];
    else
        for (i = 0; i < 4; ++i) res[i] = res1[i];
}

int main() {
    int i, j, r, c, q, supply_left = 0, total_cost = 0, cell[4];
    int results[N_ROWS][N_COLS] = { 0 };

    for (i = 0; i < N_ROWS; ++i) supply_left += supply[i];
    while (supply_left > 0) {
        next_cell(cell);
        r = cell[0];
        c = cell[1];
        q = (demand[c] <= supply[r]) ? demand[c] : supply[r];
        demand[c] -= q;
        if (!demand[c]) col_done[c] = TRUE;
        supply[r] -= q;
        if (!supply[r]) row_done[r] = TRUE;
        results[r][c] = q;
        supply_left -= q;
        total_cost += q * costs[r][c];
    }

    printf("    A   B   C   D   E\n");
    for (i = 0; i < N_ROWS; ++i) {
        printf("%c", 'W' + i);
        for (j = 0; j < N_COLS; ++j) printf("  %2d", results[i][j]);
        printf("\n");
    }
    printf("\nTotal cost = %d\n", total_cost);
    return 0;
}
