#include <stdio.h>
#include <stdlib.h>

typedef struct {
    char *word;
    int weight;
} item_t;

item_t items[] = {
    {"alliance",     -624},
    {"archbishop",   -915},
    {"balm",          397},
    {"bonnet",        452},
    {"brute",         870},
    {"centipede",    -658},
    {"cobol",         362},
    {"covariate",     590},
    {"departure",     952},
    {"deploy",         44},
    {"diophantine",   645},
    {"efferent",       54},
    {"elysee",       -326},
    {"eradicate",     376},
    {"escritoire",    856},
    {"exorcism",     -983},
    {"fiat",          170},
    {"filmy",        -874},
    {"flatworm",      503},
    {"gestapo",       915},
    {"infra",        -847},
    {"isis",         -982},
    {"lindholm",      999},
    {"markham",       475},
    {"mincemeat",    -880},
    {"moresby",       756},
    {"mycenae",       183},
    {"plugging",     -266},
    {"smokescreen",   423},
    {"speakeasy",    -745},
    {"vein",          813},
};

int n = sizeof (items) / sizeof (item_t);
int *set;

void subsum (int i, int weight) {
    int j;
    if (i && !weight) {
        for (j = 0; j < i; j++) {
            item_t item = items[set[j]];
            printf("%s%s", j ? " " : "", items[set[j]].word);
        }
        printf("\n");
    }
    for (j = i ? set[i - 1] + 1: 0; j < n; j++) {
        set[i] = j;
        subsum(i + 1, weight + items[j].weight);
    }
}

int main () {
    set = malloc(n * sizeof (int));
    subsum(0, 0);
    return 0;
}
