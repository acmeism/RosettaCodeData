#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

struct RealSet {
    bool(*contains)(struct RealSet*, struct RealSet*, double);
    struct RealSet *left;
    struct RealSet *right;
    double low, high;
};

typedef enum {
    CLOSED,
    LEFT_OPEN,
    RIGHT_OPEN,
    BOTH_OPEN,
} RangeType;

double length(struct RealSet *self) {
    const double interval = 0.00001;
    double p = self->low;
    int count = 0;

    if (isinf(self->low) || isinf(self->high)) return -1.0;
    if (self->high <= self->low) return 0.0;

    do {
        if (self->contains(self, NULL, p)) count++;
        p += interval;
    } while (p < self->high);
    return count * interval;
}

bool empty(struct RealSet *self) {
    if (self->low == self->high) {
        return !self->contains(self, NULL, self->low);
    }
    return length(self) == 0.0;
}

static bool contains_closed(struct RealSet *self, struct RealSet *_, double d) {
    return self->low <= d && d <= self->high;
}

static bool contains_left_open(struct RealSet *self, struct RealSet *_, double d) {
    return self->low < d && d <= self->high;
}

static bool contains_right_open(struct RealSet *self, struct RealSet *_, double d) {
    return self->low <= d && d < self->high;
}

static bool contains_both_open(struct RealSet *self, struct RealSet *_, double d) {
    return self->low < d && d < self->high;
}

static bool contains_intersect(struct RealSet *self, struct RealSet *_, double d) {
    return self->left->contains(self->left, NULL, d) && self->right->contains(self->right, NULL, d);
}

static bool contains_union(struct RealSet *self, struct RealSet *_, double d) {
    return self->left->contains(self->left, NULL, d) || self->right->contains(self->right, NULL, d);
}

static bool contains_subtract(struct RealSet *self, struct RealSet *_, double d) {
    return self->left->contains(self->left, NULL, d) && !self->right->contains(self->right, NULL, d);
}

struct RealSet* makeSet(double low, double high, RangeType type) {
    bool(*contains)(struct RealSet*, struct RealSet*, double);
    struct RealSet *rs;

    switch (type) {
    case CLOSED:
        contains = contains_closed;
        break;
    case LEFT_OPEN:
        contains = contains_left_open;
        break;
    case RIGHT_OPEN:
        contains = contains_right_open;
        break;
    case BOTH_OPEN:
        contains = contains_both_open;
        break;
    default:
        return NULL;
    }

    rs = malloc(sizeof(struct RealSet));
    rs->contains = contains;
    rs->left = NULL;
    rs->right = NULL;
    rs->low = low;
    rs->high = high;
    return rs;
}

struct RealSet* makeIntersect(struct RealSet *left, struct RealSet *right) {
    struct RealSet *rs = malloc(sizeof(struct RealSet));
    rs->contains = contains_intersect;
    rs->left = left;
    rs->right = right;
    rs->low = fmin(left->low, right->low);
    rs->high = fmin(left->high, right->high);
    return rs;
}

struct RealSet* makeUnion(struct RealSet *left, struct RealSet *right) {
    struct RealSet *rs = malloc(sizeof(struct RealSet));
    rs->contains = contains_union;
    rs->left = left;
    rs->right = right;
    rs->low = fmin(left->low, right->low);
    rs->high = fmin(left->high, right->high);
    return rs;
}

struct RealSet* makeSubtract(struct RealSet *left, struct RealSet *right) {
    struct RealSet *rs = malloc(sizeof(struct RealSet));
    rs->contains = contains_subtract;
    rs->left = left;
    rs->right = right;
    rs->low = left->low;
    rs->high = left->high;
    return rs;
}

int main() {
    struct RealSet *a = makeSet(0.0, 1.0, LEFT_OPEN);
    struct RealSet *b = makeSet(0.0, 2.0, RIGHT_OPEN);
    struct RealSet *c = makeSet(1.0, 2.0, LEFT_OPEN);
    struct RealSet *d = makeSet(0.0, 3.0, RIGHT_OPEN);
    struct RealSet *e = makeSet(0.0, 1.0, BOTH_OPEN);
    struct RealSet *f = makeSet(0.0, 1.0, CLOSED);
    struct RealSet *g = makeSet(0.0, 0.0, CLOSED);
    int i;

    for (i = 0; i < 3; ++i) {
        struct RealSet *t;

        t = makeUnion(a, b);
        printf("(0, 1]   union   [0, 2) contains %d is %d\n", i, t->contains(t, NULL, i));
        free(t);

        t = makeIntersect(b, c);
        printf("[0, 2) intersect (1, 2] contains %d is %d\n", i, t->contains(t, NULL, i));
        free(t);

        t = makeSubtract(d, e);
        printf("[0, 3)     -     (0, 1) contains %d is %d\n", i, t->contains(t, NULL, i));
        free(t);

        t = makeSubtract(d, f);
        printf("[0, 3)     -     [0, 1] contains %d is %d\n", i, t->contains(t, NULL, i));
        free(t);

        printf("\n");
    }

    printf("[0, 0] is empty %d\n", empty(g));

    free(a);
    free(b);
    free(c);
    free(d);
    free(e);
    free(f);
    free(g);

    return 0;
}
