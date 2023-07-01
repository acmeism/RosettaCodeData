#include <stdio.h>

#define TRUE 1
#define FALSE 0

typedef int bool;

typedef struct {
    int start, stop, incr;
    const char *comment;
} S;

S examples[9] = {
    {-2, 2, 1, "Normal"},
    {-2, 2, 0, "Zero increment"},
    {-2, 2, -1, "Increments away from stop value"},
    {-2, 2, 10, "First increment is beyond stop value"},
    {2, -2, 1, "Start more than stop: positive increment"},
    {2, 2, 1, "Start equal stop: positive increment"},
    {2, 2, -1, "Start equal stop: negative increment"},
    {2, 2, 0, "Start equal stop: zero increment"},
    {0, 0, 0, "Start equal stop equal zero: zero increment"}
};

int main() {
    int i, j, c;
    bool empty;
    S s;
    const int limit = 10;
    for (i = 0; i < 9; ++i) {
        s = examples[i];
        printf("%s\n", s.comment);
        printf("Range(%d, %d, %d) -> [", s.start, s.stop, s.incr);
        empty = TRUE;
        for (j = s.start, c = 0; j <= s.stop && c < limit; j += s.incr, ++c) {
            printf("%d ", j);
            empty = FALSE;
        }
        if (!empty) printf("\b");
        printf("]\n\n");
    }
    return 0;
}
