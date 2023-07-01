#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct edge { int to; struct edge *next; };
struct node { int group; struct edge *e; };

int **consolidate(int **x)
{
#	define alloc(v, size) v = calloc(size, sizeof(v[0]));
	int group, n_groups, n_nodes;
	int n_edges = 0;
	struct edge *edges, *ep;
	struct node *nodes;
	int pos, *stack, **ret;

	void add_edge(int a, int b) {
		ep->to = b;
		ep->next = nodes[a].e;
		nodes[a].e = ep;
		ep++;
	}

	void traverse(int a) {
		if (nodes[a].group) return;

		nodes[a].group = group;
		stack[pos++] = a;

		for (struct edge *e = nodes[a].e; e; e = e->next)
			traverse(e->to);
	}

	n_groups = n_nodes = 0;
	for (int i = 0; x[i]; i++, n_groups++)
		for (int j = 0; x[i][j]; j++) {
			n_edges ++;
			if (x[i][j] >= n_nodes)
				n_nodes = x[i][j] + 1;
		}

	alloc(ret, n_nodes);
	alloc(nodes, n_nodes);
	alloc(stack, n_nodes);
	ep = alloc(edges, n_edges);

	for (int i = 0; x[i]; i++)
		for (int *s = x[i], j = 0; s[j]; j++)
			add_edge(s[j], s[j + 1] ? s[j + 1] : s[0]);

	group = 0;
	for (int i = 1; i < n_nodes; i++) {
		if (nodes[i].group) continue;

		group++, pos = 0;
		traverse(i);

		stack[pos++] = 0;
		ret[group - 1] = malloc(sizeof(int) * pos);
		memcpy(ret[group - 1], stack, sizeof(int) * pos);
	}

	free(edges);
	free(stack);
	free(nodes);

	// caller is responsible for freeing ret
	return realloc(ret, sizeof(ret[0]) * (1 + group));
#	undef alloc
}

void show_sets(int **x)
{
	for (int i = 0; x[i]; i++) {
		printf("%d: ", i);
		for (int j = 0; x[i][j]; j++)
			printf(" %d", x[i][j]);
		putchar('\n');
	}
}

int main(void)
{
	int *x[] = {
		(int[]) {1, 2, 0},	// 0: end of set
		(int[]) {3, 4, 0},
		(int[]) {3, 1, 0},
		(int[]) {0},		// empty set
		(int[]) {5, 6, 0},
		(int[]) {7, 6, 0},
		(int[]) {3, 9, 10, 0},
		0			// 0: end of sets
	};

	puts("input:");
	show_sets(x);

	puts("components:");
	show_sets(consolidate(x));

	return 0;
}
