#include <stdio.h>
#include <stdlib.h>

typedef struct {
    char *name;
    int weight;
    int value;
} item_t;

item_t items[] = {
    {"map",                      9,   150},
    {"compass",                 13,    35},
    {"water",                  153,   200},
    {"sandwich",                50,   160},
    {"glucose",                 15,    60},
    {"tin",                     68,    45},
    {"banana",                  27,    60},
    {"apple",                   39,    40},
    {"cheese",                  23,    30},
    {"beer",                    52,    10},
    {"suntan cream",            11,    70},
    {"camera",                  32,    30},
    {"T-shirt",                 24,    15},
    {"trousers",                48,    10},
    {"umbrella",                73,    40},
    {"waterproof trousers",     42,    70},
    {"waterproof overclothes",  43,    75},
    {"note-case",               22,    80},
    {"sunglasses",               7,    20},
    {"towel",                   18,    12},
    {"socks",                    4,    50},
    {"book",                    30,    10},
};

int *knapsack (item_t *items, int n, int w) {
    int i, j, a, b, *mm, **m, *s;
    mm = calloc((n + 1) * (w + 1), sizeof (int));
    m = malloc((n + 1) * sizeof (int *));
    m[0] = mm;
    for (i = 1; i <= n; i++) {
        m[i] = &mm[i * (w + 1)];
        for (j = 0; j <= w; j++) {
            if (items[i - 1].weight > j) {
                m[i][j] = m[i - 1][j];
            }
            else {
                a = m[i - 1][j];
                b = m[i - 1][j - items[i - 1].weight] + items[i - 1].value;
                m[i][j] = a > b ? a : b;
            }
        }
    }
    s = calloc(n, sizeof (int));
    for (i = n, j = w; i > 0; i--) {
        if (m[i][j] > m[i - 1][j]) {
            s[i - 1] = 1;
            j -= items[i - 1].weight;
        }
    }
    free(mm);
    free(m);
    return s;
}

int main () {
    int i, n, tw = 0, tv = 0, *s;
    n = sizeof (items) / sizeof (item_t);
    s = knapsack(items, n, 400);
    for (i = 0; i < n; i++) {
        if (s[i]) {
            printf("%-22s %5d %5d\n", items[i].name, items[i].weight, items[i].value);
            tw += items[i].weight;
            tv += items[i].value;
        }
    }
    printf("%-22s %5d %5d\n", "totals:", tw, tv);
    return 0;
}
