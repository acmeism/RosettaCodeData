#include <stdio.h>
#include <stdlib.h>

typedef struct {
    char *name;
    double value;
    double weight;
    double volume;
} item_t;

item_t items[] = {
    {"panacea", 3000.0, 0.3, 0.025},
    {"ichor",   1800.0, 0.2, 0.015},
    {"gold",    2500.0, 2.0, 0.002},
};

int n = sizeof (items) / sizeof (item_t);
int *count;
int *best;
double best_value;

void knapsack (int i, double value, double weight, double volume) {
    int j, m1, m2, m;
    if (i == n) {
        if (value > best_value) {
            best_value = value;
            for (j = 0; j < n; j++) {
                best[j] = count[j];
            }
        }
        return;
    }
    m1 = weight / items[i].weight;
    m2 = volume / items[i].volume;
    m = m1 < m2 ? m1 : m2;
    for (count[i] = m; count[i] >= 0; count[i]--) {
        knapsack(
            i + 1,
            value + count[i] * items[i].value,
            weight - count[i] * items[i].weight,
            volume - count[i] * items[i].volume
        );
    }
}

int main () {
    count = malloc(n * sizeof (int));
    best = malloc(n * sizeof (int));
    best_value = 0;
    knapsack(0, 0.0, 25.0, 0.25);
    int i;
    for (i = 0; i < n; i++) {
        printf("%d %s\n", best[i], items[i].name);
    }
    printf("best value: %.0f\n", best_value);
    free(count); free(best);
    return 0;
}
