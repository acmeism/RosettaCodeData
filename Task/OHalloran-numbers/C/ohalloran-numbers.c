#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

int main() {
    bool *found = calloc(1000, sizeof(bool)); // all false initially
    int i, l, w, h, lw, sa;
    for (l = 1; l < 498; ++l) {
        for (w = 1; w <= l; ++w) {
            lw = l * w;
            if (lw >= 498) break;
            for (h = 1; h <= w; ++h) {
                sa = (lw + w*h + h*l) * 2;
                if (sa < 1000) found[sa] = true;
            }
        }
    }
    printf("All known O'Halloran numbers:\n[");
    for (i = 6; i < 1000; i += 2) {
        if (!found[i]) printf("%d, ", i);
    }
    printf("\b\b]\n");
    free(found);
    return 0;
}
