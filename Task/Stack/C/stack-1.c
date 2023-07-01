#include <stdio.h>
#include <stdlib.h>

/* to read expanded code, run through cpp | indent -st */
#define DECL_STACK_TYPE(type, name)					\
typedef struct stk_##name##_t{type *buf; size_t alloc,len;}*stk_##name;	\
stk_##name stk_##name##_create(size_t init_size) {			\
	stk_##name s; if (!init_size) init_size = 4;			\
	s = malloc(sizeof(struct stk_##name##_t));			\
	if (!s) return 0;						\
	s->buf = malloc(sizeof(type) * init_size);			\
	if (!s->buf) { free(s); return 0; }				\
	s->len = 0, s->alloc = init_size;				\
	return s; }							\
int stk_##name##_push(stk_##name s, type item) {			\
	type *tmp;							\
	if (s->len >= s->alloc) {					\
		tmp = realloc(s->buf, s->alloc*2*sizeof(type));		\
		if (!tmp) return -1; s->buf = tmp;			\
		s->alloc *= 2; }					\
	s->buf[s->len++] = item;					\
	return s->len; }						\
type stk_##name##_pop(stk_##name s) {					\
	type tmp;							\
	if (!s->len) abort();						\
	tmp = s->buf[--s->len];						\
	if (s->len * 2 <= s->alloc && s->alloc >= 8) {			\
		s->alloc /= 2;						\
		s->buf = realloc(s->buf, s->alloc * sizeof(type));}	\
	return tmp; }							\
void stk_##name##_delete(stk_##name s) {				\
	free(s->buf); free(s); }

#define stk_empty(s) (!(s)->len)
#define stk_size(s) ((s)->len)

DECL_STACK_TYPE(int, int)

int main(void)
{
	int i;
	stk_int stk = stk_int_create(0);

	printf("pushing: ");
	for (i = 'a'; i <= 'z'; i++) {
		printf(" %c", i);
		stk_int_push(stk, i);
	}

	printf("\nsize now: %d", stk_size(stk));
	printf("\nstack is%s empty\n", stk_empty(stk) ? "" : " not");

	printf("\npoppoing:");
	while (stk_size(stk))
		printf(" %c", stk_int_pop(stk));
	printf("\nsize now: %d", stk_size(stk));
	printf("\nstack is%s empty\n", stk_empty(stk) ? "" : " not");

	/* stk_int_pop(stk); <-- will abort() */
	stk_int_delete(stk);
	return 0;
}
