typedef struct _pq_node_t {
    long int key;
    struct _pq_node_t *next, *down;
} pq_node_t, *heap_t;

extern heap_t heap_merge(heap_t, heap_t);
extern heap_t heap_pop(heap_t);

#define NEW_PQ_ELE(p, k) \
    do { \
	(p) = (typeof(p)) malloc(sizeof(*p)); \
	((pq_node_t *) (p))->next = ((pq_node_t *) (p))->down = NULL; \
	((pq_node_t *) (p))->key = (k); \
    } while (0)

#define HEAP_PUSH(p, k, h) \
    NEW_PQ_ELE(p, k); \
    *(h) = heap_merge(((pq_node_t *) (p)), *(h))
