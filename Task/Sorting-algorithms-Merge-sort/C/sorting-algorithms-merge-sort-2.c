#include <stdlib.h>
#include <stdio.h>

typedef struct link_s *link, link_t;
struct link_s { double v; link next; };

const link_t fnil = { 0./0., &fnil }; // sentinel
const link const nil = &fnil;

link list_from_array(double *a, int len)
{
	link p = nil;
	while (len--) {
		link pp = malloc(sizeof(*pp));
		pp->v = a[len];
		pp->next = p;
		p = pp;
	}
	return p;
}

void show_list(link a)
{
	for (; a != nil; a = a->next)
		printf("%g ", a->v);
	putchar('\n');
}

link merge(link a, link b)
{
	link head = &(link_t){0, nil}, tail = head;
	while (a != nil && b != nil) {
		link *p = a->v <= b->v ? &a : &b;
		tail->next = *p;
		*p = (*p)->next;
		tail = tail->next;
	}
	tail->next = a != nil ? a : b;
	return head->next;
}

link merge_sort(link p)
{
	if (p->next == nil) return p;

	link tail = p, mid = p;
	// Seek to the middle of the list. This is O(n) for list
	// length, so O(n log n) complexity to overall merge sort
	// that an array wouldn't have to deal with.
	while (1) {
		tail = tail->next->next;
		if (tail == nil) break;
		mid = mid->next;
	}

	tail = mid->next;
	mid->next = nil;

	return merge(merge_sort(p), merge_sort(tail));
}

int main(void)
{
	double x[] = {5,3,6,1,2,6,2,0,3,5,7,8,2,4,9};
	link p = list_from_array(x, sizeof(x)/sizeof(x[0]));

	puts("list: "); show_list(p);
	puts("sort: "); show_list(merge_sort(p));
	return 0;
}
