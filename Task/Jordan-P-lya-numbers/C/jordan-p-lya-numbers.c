#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <locale.h>
#include <glib.h>

uint64_t factorials[19] = {1, 1};

void cacheFactorials() {
    uint64_t fact = 1;
    int i;
    for (i = 2; i < 19; ++i) {
        fact *= i;
        factorials[i] = fact;
    }
}

int findNearestFact(uint64_t n) {
    int i;
    for (i = 1; i < 19; ++i) {
        if (factorials[i] >= n) return i;
    }
    return 18;
}

int findNearestInArray(GArray *a, uint64_t n) {
    int l = 0, r = a->len, m;
    while (l < r) {
        m = (l + r)/2;
        if (g_array_index(a, uint64_t, m) > n) {
            r = m;
        } else {
            l = m + 1;
        }
    }
    if (r > 0 && g_array_index(a, uint64_t, r-1) == n) return r - 1;
    return r;
}

GArray *jordanPolya(uint64_t limit) {
    int i, ix, k, l, p;
    uint64_t t, rk, kl;
    GArray *res = g_array_new(false, false, sizeof(uint64_t));
    ix = findNearestFact(limit);
    for (i = 0; i <= ix; ++i) {
        t = factorials[i];
        g_array_append_val(res, t);
    }
    k = 2;
    while (k < res->len) {
        rk = g_array_index(res, uint64_t, k);
        for (l = 2; l < res->len; ++l) {
            t = g_array_index(res, uint64_t, l);
            if (t > limit/rk) break;
            kl = t * rk;
            while (true) {
                p = findNearestInArray(res, kl);
                if (p < res->len && g_array_index(res, uint64_t, p) != kl) {
                    g_array_insert_val(res, p, kl);
                } else if (p == res->len) {
                    g_array_append_val(res, kl);
                }
                if (kl > limit/rk) break;
                kl *= rk;
            }
        }
        ++k;
    }
    return g_array_remove_index(res, 0);
}

GArray *decompose(uint64_t n, int start) {
    uint64_t i, s, t, m, prod;
    GArray *f, *g;
    for (s = start; s > 0; --s) {
        f = g_array_new(false, false, sizeof(uint64_t));
        if (s < 2) return f;
        m = n;
        while (!(m % factorials[s])) {
            g_array_append_val(f, s);
            m /= factorials[s];
            if (m == 1) return f;
        }
        if (f->len > 0) {
            g = decompose(m, s - 1);
            if (g->len > 0) {
                prod = 1;
                for (i = 0; i < g->len; ++i) {
                    prod *= factorials[(int)g_array_index(g, uint64_t, i)];
                }
                if (prod == m) {
                    for (i = 0; i < g->len; ++i) {
                        t = g_array_index(g, uint64_t, i);
                        g_array_append_val(f, t);
                    }
                    g_array_free(g, true);
                    return f;
                }
            }
            g_array_free(g, true);
        }
        g_array_free(f, true);
    }
}

char *superscript(int n) {
    char* ss[] = {"⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"};
    if (n < 10) return ss[n];
    static char buf[7];
    sprintf(buf, "%s%s", ss[n/10], ss[n%10]);
    return buf;
}

int main() {
    int i, j, ix, count;
    uint64_t t, u;
    GArray *v, *w;
    cacheFactorials();
    v = jordanPolya(1ull << 53);
    printf("First 50 Jordan-Pólya numbers:\n");
    for (i = 0; i < 50; ++i) {
        printf("%4ju ", g_array_index(v, uint64_t, i));
        if (!((i + 1) % 10)) printf("\n");
    }
    printf("\nThe largest Jordan-Pólya number before 100 millon: ");
    setlocale(LC_NUMERIC, "");
    ix = findNearestInArray(v, 100000000ull);
    printf("%'ju\n\n", g_array_index(v, uint64_t, ix - 1));

    uint64_t targets[5] = {800, 1050, 1800, 2800, 3800};
    for (i = 0; i < 5; ++i) {
        t = g_array_index(v, uint64_t, targets[i] - 1);
        printf("The %'juth Jordan-Pólya number is : %'ju\n", targets[i], t);
        w = decompose(t, 18);
        count = 1;
        t = g_array_index(w, uint64_t, 0);
        printf(" = ");
        for (j = 1; j < w->len; ++j) {
            u = g_array_index(w, uint64_t, j);
            if (u != t) {
                if (count == 1) {
                    printf("%ju! x ", t);
                } else {
                    printf("(%ju!)%s x ", t, superscript(count));
                    count = 1;
                }
                t = u;
            } else {
                ++count;
            }
        }
        if (count == 1) {
            printf("%ju! x ", t);
        } else {
            printf("(%ju!)%s x ", t, superscript(count));
        }
        printf("\b\b \n\n");
        g_array_free(w, true);
    }
    g_array_free(v, true);
    return 0;
}
