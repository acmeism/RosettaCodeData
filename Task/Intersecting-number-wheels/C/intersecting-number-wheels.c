#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Wheel {
    char *seq;
    int len;
    int pos;
};

struct Wheel *create(char *seq) {
    struct Wheel *w = malloc(sizeof(struct Wheel));
    if (w == NULL) {
        return NULL;
    }

    w->seq = seq;
    w->len = strlen(seq);
    w->pos = 0;

    return w;
}

char cycle(struct Wheel *w) {
    char c = w->seq[w->pos];
    w->pos = (w->pos + 1) % w->len;
    return c;
}

struct Map {
    struct Wheel *v;
    struct Map *next;
    char k;
};

struct Map *insert(char k, struct Wheel *v, struct Map *head) {
    struct Map *m = malloc(sizeof(struct Map));
    if (m == NULL) {
        return NULL;
    }

    m->k = k;
    m->v = v;
    m->next = head;

    return m;
}

struct Wheel *find(char k, struct Map *m) {
    struct Map *ptr = m;

    while (ptr != NULL) {
        if (ptr->k == k) {
            return ptr->v;
        }
        ptr = ptr->next;
    }

    return NULL;
}

void printOne(char k, struct Map *m) {
    struct Wheel *w = find(k, m);
    char c;

    if (w == NULL) {
        printf("Missing the wheel for: %c\n", k);
        exit(1);
    }

    c = cycle(w);
    if ('0' <= c && c <= '9') {
        printf(" %c", c);
    } else {
        printOne(c, m);
    }
}

void exec(char start, struct Map *m) {
    struct Wheel *w;
    int i;

    if (m == NULL) {
        printf("Unable to proceed.");
        return;
    }

    for (i = 0; i < 20; i++) {
        printOne(start, m);
    }
    printf("\n");
}

void group1() {
    struct Wheel *a = create("123");

    struct Map *m = insert('A', a, NULL);

    exec('A', m);
}

void group2() {
    struct Wheel *a = create("1B2");
    struct Wheel *b = create("34");

    struct Map *m = insert('A', a, NULL);
    m = insert('B', b, m);

    exec('A', m);
}

void group3() {
    struct Wheel *a = create("1DD");
    struct Wheel *d = create("678");

    struct Map *m = insert('A', a, NULL);
    m = insert('D', d, m);

    exec('A', m);
}

void group4() {
    struct Wheel *a = create("1BC");
    struct Wheel *b = create("34");
    struct Wheel *c = create("5B");

    struct Map *m = insert('A', a, NULL);
    m = insert('B', b, m);
    m = insert('C', c, m);

    exec('A', m);
}

int main() {
    group1();
    group2();
    group3();
    group4();

    return 0;
}
