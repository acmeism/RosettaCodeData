#include <stdio.h>
#include <stdlib.h>

typedef struct { void * data; int pri; } q_elem_t;
typedef struct { q_elem_t *buf; int n, alloc; } pri_queue_t, *pri_queue;

#define priq_purge(q) (q)->n = 1
#define priq_size(q) ((q)->n - 1)
/* first element in array not used to simplify indices */
pri_queue priq_new(int size)
{
	if (size < 4) size = 4;

	pri_queue q = malloc(sizeof(pri_queue_t));
	q->buf = malloc(sizeof(q_elem_t) * size);
	q->alloc = size;
	q->n = 1;

	return q;
}

void priq_push(pri_queue q, void *data, int pri)
{
	q_elem_t *b;
	int n, m;

	if (q->n >= q->alloc) {
		q->alloc *= 2;
		b = q->buf = realloc(q->buf, sizeof(q_elem_t) * q->alloc);
	} else
		b = q->buf;

	n = q->n++;
	/* append at end, then up heap */
	while ((m = n / 2) && pri < b[m].pri) {
		b[n] = b[m];
		n = m;
	}
	b[n].data = data;
	b[n].pri = pri;
}

/* remove top item. returns 0 if empty. *pri can be null. */
void * priq_pop(pri_queue q, int *pri)
{
	void *out;
	if (q->n == 1) return 0;

	q_elem_t *b = q->buf;

	out = b[1].data;
	if (pri) *pri = b[1].pri;

	/* pull last item to top, then down heap. */
	--q->n;

	int n = 1, m;
	while ((m = n * 2) < q->n) {
		if (m + 1 < q->n && b[m].pri > b[m + 1].pri) m++;

		if (b[q->n].pri <= b[m].pri) break;
		b[n] = b[m];
		n = m;
	}

	b[n] = b[q->n];
	if (q->n < q->alloc / 2 && q->n >= 16)
		q->buf = realloc(q->buf, (q->alloc /= 2) * sizeof(b[0]));

	return out;
}

/* get the top element without removing it from queue */
void* priq_top(pri_queue q, int *pri)
{
	if (q->n == 1) return 0;
	if (pri) *pri = q->buf[1].pri;
	return q->buf[1].data;
}

/* this is O(n log n), but probably not the best */
void priq_combine(pri_queue q, pri_queue q2)
{
	int i;
	q_elem_t *e = q2->buf + 1;

	for (i = q2->n - 1; i >= 1; i--, e++)
		priq_push(q, e->data, e->pri);
	priq_purge(q2);
}

int main()
{
	int i, p;
	const char *c, *tasks[] ={
		"Clear drains", "Feed cat", "Make tea", "Solve RC tasks", "Tax return" };
	int pri[] = { 3, 4, 5, 1, 2 };

	/* make two queues */
	pri_queue q = priq_new(0), q2 = priq_new(0);

	/* push all 5 tasks into q */
	for (i = 0; i < 5; i++)
		priq_push(q, tasks[i], pri[i]);

	/* pop them and print one by one */
	while ((c = priq_pop(q, &p)))
		printf("%d: %s\n", p, c);

	/* put a million random tasks in each queue */
	for (i = 0; i < 1 << 20; i++) {
		p = rand() / ( RAND_MAX / 5 );
		priq_push(q, tasks[p], pri[p]);

		p = rand() / ( RAND_MAX / 5 );
		priq_push(q2, tasks[p], pri[p]);
	}

	printf("\nq has %d items, q2 has %d items\n", priq_size(q), priq_size(q2));

	/* merge q2 into q; q2 is empty */
	priq_combine(q, q2);
	printf("After merge, q has %d items, q2 has %d items\n",
		priq_size(q), priq_size(q2));

	/* pop q until it's empty */
	for (i = 0; (c = priq_pop(q, 0)); i++);
	printf("Popped %d items out of q\n", i);

	return 0;
}
