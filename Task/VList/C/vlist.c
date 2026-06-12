#include <stdio.h>
#include <stdlib.h>

typedef struct sublist{
	struct sublist* next;
	int *buf;
} sublist_t;

sublist_t* sublist_new(size_t s)
{
	sublist_t* sub = malloc(sizeof(sublist_t) + sizeof(int) * s);
	sub->buf = (int*)(sub + 1);
	sub->next = 0;
	return sub;
}

typedef struct vlist_t {
	sublist_t* head;
	size_t last_size, ofs;
} vlist_t, *vlist;

vlist v_new()
{
	vlist v = malloc(sizeof(vlist_t));
	v->head = sublist_new(1);
	v->last_size = 1;
	v->ofs = 0;
	return v;
}

void v_del(vlist v)
{
	sublist_t *s;
	while (v->head) {
		s = v->head->next;
		free(v->head);
		v->head = s;
	}
	free(v);
}

inline size_t v_size(vlist v)
{
	return v->last_size * 2 - v->ofs - 2;
}

int* v_addr(vlist v, size_t idx)
{
	sublist_t *s = v->head;
	size_t top = v->last_size, i = idx + v->ofs;

	if (i + 2 >= (top << 1)) {
		fprintf(stderr, "!: idx %d out of range\n", (int)idx);
		abort();
	}
	while (s && i >= top) {
		s = s->next, i ^= top;
		top >>= 1;
	}
	return s->buf + i;
}

inline int v_elem(vlist v, size_t idx)
{
	return *v_addr(v, idx);
}

int* v_unshift(vlist v, int x)
{
	sublist_t* s;
	int *p;

	if (!v->ofs) {
		if (!(s = sublist_new(v->last_size << 1))) {
			fprintf(stderr, "?: alloc failure\n");
			return 0;
		}
		v->ofs = (v->last_size <<= 1);
		s->next = v->head;
		v->head = s;
	}
	*(p = v->head->buf + --v->ofs) = x;
	return p;
}

int v_shift(vlist v)
{
	sublist_t* s;
	int x;

	if (v->last_size == 1 && v->ofs == 1) {
		fprintf(stderr, "!: empty list\n");
		abort();
	}
	x = v->head->buf[v->ofs++];

	if (v->ofs == v->last_size) {
		v->ofs = 0;
		if (v->last_size > 1) {
			s = v->head, v->head = s->next;
			v->last_size >>= 1;
			free(s);
		}
	}
	return x;
}

int main()
{
	int i;

	vlist v = v_new();
	for (i = 0; i < 10; i++) v_unshift(v, i);

	printf("size: %d\n", v_size(v));
	for (i = 0; i < 10; i++) printf("v[%d] = %d\n", i, v_elem(v, i));
	for (i = 0; i < 10; i++) printf("shift: %d\n", v_shift(v));

	/* v_shift(v); */ /* <- boom */

	v_del(v);
	return 0;
}
