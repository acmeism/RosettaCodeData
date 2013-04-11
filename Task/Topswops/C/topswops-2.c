#define _GNU_SOURCE
#include <stdio.h>
#include <string.h>
#include <pthread.h>
#include <sched.h>

#define MAX_CPUS 8 // increase this if you got more CPUs/cores

typedef struct { char v[16]; } deck;

int n, best[16];

// Update a shared variable by spinlock.  Since this program really only
// enters locks dozens of times, a pthread_mutex_lock() would work
// equally fine, but RC already has plenty of examples for that.
#define SWAP_OR_RETRY(var, old, new)					\
	if (!__sync_bool_compare_and_swap(&(var), old, new)) {		\
		volatile int spin = 64;					\
		while (spin--);						\
		continue; }

void tryswaps(deck *a, int f, int s, int d) {
#define A a->v
#define B b->v

	while (best[n] < d) {
		int t = best[n];
		SWAP_OR_RETRY(best[n], t, d);
	}

#define TEST(x)									\
	case x: if ((A[15-x] == 15-x || (A[15-x] == -1 && !(f & 1<<(15-x))))	\
			&& (A[15-x] == -1 || d + best[15-x] >= best[n]))	\
			break;							\
		if (d + best[15-x] <= best[n]) return;				\
		s = 14 - x

	switch (15 - s) {
		TEST(0);  TEST(1);  TEST(2);  TEST(3);  TEST(4);
		TEST(5);  TEST(6);  TEST(7);  TEST(8);  TEST(9);
		TEST(10); TEST(11); TEST(12); TEST(13); TEST(14);
		return;
	}
#undef TEST

	deck *b = a + 1;
	*b = *a;
	d++;

#define FLIP(x)							\
	if (A[x] == x || ((A[x] == -1) && !(f & (1<<x)))) {	\
		B[0] = x;					\
		for (int j = x; j--; ) B[x-j] = A[j];		\
		tryswaps(b, f|(1<<x), s, d); }			\
	if (s == x) return;

	FLIP(1);  FLIP(2);  FLIP(3);  FLIP(4);  FLIP(5);
	FLIP(6);  FLIP(7);  FLIP(8);  FLIP(9);  FLIP(10);
	FLIP(11); FLIP(12); FLIP(13); FLIP(14); FLIP(15);
#undef FLIP
}

int num_cpus(void) {
	cpu_set_t ct;
	sched_getaffinity(0, sizeof(ct), &ct);

	int cnt = 0;
	for (int i = 0; i < MAX_CPUS; i++)
		if (CPU_ISSET(i, &ct))
			cnt++;

	return cnt;
}

struct work { int id; deck x[256]; } jobs[MAX_CPUS];
int first_swap;

void *thread_start(void *arg) {
	struct work *job = arg;
	while (1) {
		int at = first_swap;
		if (at >= n) return 0;

		SWAP_OR_RETRY(first_swap, at, at + 1);

		memset(job->x, -1, sizeof(deck));
		job->x[0].v[at] = 0;
		job->x[0].v[0] = at;
		tryswaps(job->x, 1 | (1 << at), n - 1, 1);
	}
}

int main(void) {
	int n_cpus = num_cpus();

	for (int i = 0; i < MAX_CPUS; i++)
		jobs[i].id = i;

	pthread_t tid[MAX_CPUS];

	for (n = 2; n <= 14; n++) {
		int top = n_cpus;
		if (top > n) top = n;

		first_swap = 1;
		for (int i = 0; i < top; i++)
			pthread_create(tid + i, 0, thread_start, jobs + i);

		for (int i = 0; i < top; i++)
			pthread_join(tid[i], 0);

		printf("%2d: %2d\n", n, best[n]);
	}

	return 0;
}
