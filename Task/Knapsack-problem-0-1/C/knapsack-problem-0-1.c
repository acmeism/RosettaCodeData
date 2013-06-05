#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

typedef struct {
        const char * name;
        int weight, value;
} item_t;

item_t item[] = {
        {"map",                     9,       150},
        {"compass",                 13,      35},
        {"water",                   153,     200},
        {"sandwich",                50,      160},
        {"glucose",                 15,      60},
        {"tin",                     68,      45},
        {"banana",                  27,      60},
        {"apple",                   39,      40},
        {"cheese",                  23,      30},
        {"beer",                    52,      10},
        {"suntancream",             11,      70},
        {"camera",                  32,      30},
        {"T-shirt",                 24,      15},
        {"trousers",                48,      10},
        {"umbrella",                73,      40},
        {"waterproof trousers",     42,      70},
        {"waterproof overclothes",  43,      75},
        {"note-case",               22,      80},
        {"sunglasses",              7,       20},
        {"towel",                   18,      12},
        {"socks",                   4,       50},
        {"book",                    30,      10}
};

#define n_items (sizeof(item)/sizeof(item_t))

typedef struct {
        uint32_t bits; /* 32 bits, can solve up to 32 items */
        int value;
} solution;


void optimal(int weight, int idx, solution *s)
{
        solution v1, v2;
        if (idx < 0) {
                s->bits = s->value = 0;
                return;
        }

        if (weight < item[idx].weight) {
                optimal(weight, idx - 1, s);
                return;
         }

        optimal(weight, idx - 1, &v1);
        optimal(weight - item[idx].weight, idx - 1, &v2);

        v2.value += item[idx].value;
        v2.bits |= (1 << idx);

        *s = (v1.value >= v2.value) ? v1 : v2;
}

int main(void)
{
        int i = 0, w = 0;
        solution s = {0, 0};
        optimal(400, n_items - 1, &s);

        for (i = 0; i < n_items; i++) {
                if (s.bits & (1 << i)) {
                        printf("%s\n", item[i].name);
                        w += item[i].weight;
                }
        }
        printf("Total value: %d; weight: %d\n", s.value, w);
        return 0;
}
