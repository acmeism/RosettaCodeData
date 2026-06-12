#include <stdio.h>
#include <stdlib.h>

typedef struct iterator_t {
    char **arr;
    char **curr;
    int len;
    int dir; // direction: 1 forward or -1 backward
} iterator_t;

iterator_t * iterator_new(char **arr, int len, int reverse) {
    iterator_t *it = (iterator_t *)malloc(sizeof(iterator_t));

    if (it == NULL) {
        return NULL;
    }

    it->arr = arr;
    it->curr = reverse ? arr + len : arr - 1;
    it->len = len;
    it->dir = reverse ? -1 : 1;

    return it;
}

char * iterator_get_next(iterator_t *it) {
    return *(it->curr += it->dir);
}

int iterator_has_next(iterator_t *it) {
    return it->dir > 0 ? it->curr < it->arr + it->len - 1 : it->curr > it->arr;
}

void iterator_advance(iterator_t *it, int steps) {
    it->curr += steps * it->dir;
}

void iterate(iterator_t *it, void (*cb)(void *)) {
    // reset the iterator first
    it->curr = it->dir > 0 ? it->arr - 1 : it->arr + it->len;

    while(iterator_has_next(it)) {
        cb(iterator_get_next(it));
    }
}

void iterate_idxs(iterator_t *it, int *idxs, int num_idxs, void (*cb)(void *)) {
    // reset the iterator first
    it->curr = it->dir > 0 ? it->arr - 1 : it->arr + it->len;

    for (int i = 0; i < num_idxs; i++) {
        int steps = i == 0 ? idxs[0] : idxs[i] - idxs[i - 1] - 1;

        iterator_advance(it, steps);
        cb(iterator_get_next(it));
    }
}

void print_str(void *str) {
    printf("%s, ", (char *)str);
}

int main(void) {
    char *days[7] = {"Monday", "Tuesday", "Wednesday", "Thursday",
                            "Friday", "Saturday", "Sunday"};
    char *colors[7] = {"Pink", "Red", "Orange", "Yellow",
                                "Green", "Blue", "Purple"};

    iterator_t *days_it = iterator_new(days, 7, 0);
    iterator_t *days_reverse_it = iterator_new(days, 7, 1);
    iterator_t *colors_it = iterator_new(colors, 7, 0);
    iterator_t *colors_reverse_it = iterator_new(colors, 7, 1);

    puts("All elements:");
    iterate(days_it, print_str); puts("");
    iterate(colors_it, print_str); puts("");

    int idxs[3] = {0, 3, 4}; // first, fourth, and fifth elements (0-indexed)

    puts("\nFirst, fourth, and fifth elements:");
    iterate_idxs(days_it, idxs, 3, print_str); puts("");
    iterate_idxs(colors_it, idxs, 3, print_str); puts("");

    puts("\nReverse first, fourth, and fifth elements:");
    iterate_idxs(days_reverse_it, idxs, 3, print_str); puts("");
    iterate_idxs(colors_reverse_it, idxs, 3, print_str); puts("");

    free(days_it);
    free(days_reverse_it);
    free(colors_it);
    free(colors_reverse_it);

    return EXIT_SUCCESS;
}
