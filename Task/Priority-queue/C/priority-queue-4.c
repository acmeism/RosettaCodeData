#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "pairheap.h"

struct task {
    pq_node_t hd;
    char task[40];
};

void main() {
    heap_t heap = NULL;
    struct task *new;

    HEAP_PUSH(new, 3, &heap);
    strcpy(new->task, "Clear drains.");

    HEAP_PUSH(new, 4, &heap);
    strcpy(new->task, "Feed cat.");

    HEAP_PUSH(new, 5, &heap);
    strcpy(new->task, "Make tea.");

    HEAP_PUSH(new, 1, &heap);
    strcpy(new->task, "Solve RC tasks.");

    HEAP_PUSH(new, 2, &heap);
    strcpy(new->task, "Tax return.");

    while (heap != NULL) {
        struct task *top = (struct task *) heap;
        printf("%s\n", top->task);
        heap = heap_pop(heap);
        free(top);
    }
}
