#include <stdlib.h>
#include "pairheap.h"

/* ---------------------------------------------------------------------------
 * Pairing heap implementation
 * --------------------------------------------------------------------------- */

static heap_t add_child(heap_t h, heap_t g) {
    if (h->down != NULL)
        g->next = h->down;
    h->down = g;
}

heap_t heap_merge(heap_t a, heap_t b) {
    if (a == NULL) return b;
    if (b == NULL) return a;
    if (a->key < b->key) {
        add_child(a, b);
        return a;
    } else {
        add_child(b, a);
        return b;
    }
}

/* NOTE: caller should have pointer to top of heap, since otherwise it won't
 *       be reclaimed.  (we do not free the top.)
 */
heap_t two_pass_merge(heap_t h) {
    if (h == NULL || h->next == NULL)
        return h;
    else {
        pq_node_t
            *a = h,
            *b = h->next,
            *rest = b->next;
        a->next = b->next = NULL;
        return heap_merge(heap_merge(a, b), two_pass_merge(rest));
    }
}

heap_t heap_pop(heap_t h) {
    return two_pass_merge(h->down);
}
