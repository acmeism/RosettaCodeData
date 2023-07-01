#include <stdio.h>
#include <stdlib.h>
#include <gmodule.h>

typedef int bool;

int main() {
    int i, n, k = 0, next, *a;
    bool foundDup = FALSE;
    gboolean alreadyUsed;
    GHashTable* used = g_hash_table_new(g_direct_hash, g_direct_equal);
    GHashTable* used1000 = g_hash_table_new(g_direct_hash, g_direct_equal);
    a = malloc(400000 * sizeof(int));
    a[0] = 0;
    g_hash_table_add(used, GINT_TO_POINTER(0));
    g_hash_table_add(used1000, GINT_TO_POINTER(0));

    for (n = 1; n <= 15 || !foundDup || k < 1001; ++n) {
        next = a[n - 1] - n;
        if (next < 1 || g_hash_table_contains(used, GINT_TO_POINTER(next))) {
            next += 2 * n;
        }
        alreadyUsed = g_hash_table_contains(used, GINT_TO_POINTER(next));
        a[n] = next;

        if (!alreadyUsed) {
            g_hash_table_add(used, GINT_TO_POINTER(next));
            if (next >= 0 && next <= 1000) {
                g_hash_table_add(used1000, GINT_TO_POINTER(next));
            }
        }

        if (n == 14) {
            printf("The first 15 terms of the Recaman's sequence are: ");
            printf("[");
            for (i = 0; i < 15; ++i) printf("%d ", a[i]);
            printf("\b]\n");
        }

        if (!foundDup && alreadyUsed) {
            printf("The first duplicated term is a[%d] = %d\n", n, next);
            foundDup = TRUE;
        }
        k = g_hash_table_size(used1000);

        if (k == 1001) {
            printf("Terms up to a[%d] are needed to generate 0 to 1000\n", n);
        }
    }
    g_hash_table_destroy(used);
    g_hash_table_destroy(used1000);
    free(a);
    return 0;
}
