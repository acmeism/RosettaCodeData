#include <stddef.h>
#include <stdlib.h>
#include <stdbool.h>

#ifndef min
#define min(x, y) ((x)<(y) ? (x) : (y))
#endif

struct edge {
	void *from;
	void *to;
};

struct components {
	int nnodes;
	void **nodes;
	struct components *next;
};

struct node {
	int index;
	int lowlink;
	bool onStack;
	void *data;
};

struct tjstate {
	int index;
	int sp;
	int nedges;
	struct edge *edges;
	struct node **stack;
	struct components *head;
	struct components *tail;
};

static int nodecmp(const void *l, const void *r)
{
	return (ptrdiff_t)l -(ptrdiff_t)((struct node *)r)->data;
}

static int strongconnect(struct node *v, struct tjstate *tj)
{
	struct node *w;

	/* Set the depth index for v to the smallest unused index */
	v->index = tj->index;
	v->lowlink = tj->index;
	tj->index++;
	tj->stack[tj->sp] = v;
	tj->sp++;
	v->onStack = true;

	for (int i = 0; i<tj->nedges; i++) {
		/* Only consider nodes reachable from v */
		if (tj->edges[i].from != v) {
			continue;
		}
		w = tj->edges[i].to;
		/* Successor w has not yet been visited; recurse on it */
		if (w->index == -1) {
			int r = strongconnect(w, tj);
			if (r != 0)
				return r;
			v->lowlink = min(v->lowlink, w->lowlink);
		/* Successor w is in stack S and hence in the current SCC */
		} else if (w->onStack) {
			v->lowlink = min(v->lowlink, w->index);
		}
	}

	/* If v is a root node, pop the stack and generate an SCC */
	if (v->lowlink == v->index) {
		struct components *ng = malloc(sizeof(struct components));
		if (ng == NULL) {
			return 2;
		}
		if (tj->tail == NULL) {
			tj->head = ng;
		} else {
			tj->tail->next = ng;
		}
		tj->tail = ng;
		ng->next = NULL;
		ng->nnodes = 0;
		do {
			tj->sp--;
			w = tj->stack[tj->sp];
			w->onStack = false;
			ng->nnodes++;
		} while (w != v);
		ng->nodes = malloc(ng->nnodes*sizeof(void *));
		if (ng == NULL) {
			return 2;
		}
		for (int i = 0; i<ng->nnodes; i++) {
			ng->nodes[i] = tj->stack[tj->sp+i]->data;
		}
	}
	return 0;
}

static int ptrcmp(const void *l, const void *r)
{
	return (ptrdiff_t)((struct node *)l)->data
		- (ptrdiff_t)((struct node *)r)->data;
}

/**
 * Calculate the strongly connected components using Tarjan's algorithm:
 * en.wikipedia.org/wiki/Tarjan%27s_strongly_connected_components_algorithm
 *
 * Returns NULL when there are invalid edges and sets the error to:
 * 1 if there was a malformed edge
 * 2 if malloc failed
 *
 * @param number of nodes
 * @param data of the nodes (assumed to be unique)
 * @param number of edges
 * @param data of edges
 * @param pointer to error code
 */
struct components *tarjans(
		int nnodes, void *nodedata[],
		int nedges, struct edge *edgedata[],
		int *error)
{
	struct node nodes[nnodes];
	struct edge edges[nedges];
	struct node *stack[nnodes];
	struct node *from, *to;
	struct tjstate tj = {0, 0, nedges, edges, stack, NULL, .tail=NULL};

	// Populate the nodes
	for (int i = 0; i<nnodes; i++) {
		nodes[i] = (struct node){-1, -1, false, nodedata[i]};
	}
	qsort(nodes, nnodes, sizeof(struct node), ptrcmp);

	// Populate the edges
	for (int i = 0; i<nedges; i++) {
		from = bsearch(edgedata[i]->from, nodes, nnodes,
			sizeof(struct node), nodecmp);
		if (from == NULL) {
			*error = 1;
			return NULL;
		}
		to = bsearch(edgedata[i]->to, nodes, nnodes,
			sizeof(struct node), nodecmp);
		if (to == NULL) {
			*error = 1;
			return NULL;
		}
		edges[i] = (struct edge){.from=from, .to=to};
	}

	//Tarjan's
	for (int i = 0; i < nnodes; i++) {
		if (nodes[i].index == -1) {
			*error = strongconnect(&nodes[i], &tj);
			if (*error != 0)
				return NULL;
		}
	}
	return tj.head;
}
