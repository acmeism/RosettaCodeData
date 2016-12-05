#include <stdio.h>
#include <threads.h>
#include <stdlib.h>

#define NUM_THREADS 5

struct timespec time1;
mtx_t forks[NUM_THREADS];

typedef struct {
	char *name;
	int left;
	int right;
} Philosopher;

Philosopher *create(char *nam, int lef, int righ) {
	Philosopher *x = malloc(sizeof(Philosopher));
	x->name = nam;
	x->left = lef;
	x->right = righ;
	return x;
}

int eat(void *data) {
	time1.tv_sec = 1;
	Philosopher *foo = (Philosopher *) data;
	mtx_lock(&forks[foo->left]);
	mtx_lock(&forks[foo->right]);
	printf("%s is eating\n",  foo->name);
	thrd_sleep(&time1, NULL);
	printf("%s is done eating\n",  foo->name);
	mtx_unlock(&forks[foo->left]);
	mtx_unlock(&forks[foo->right]);
	return 0;
}

int main(void) {
    thrd_t threadId[NUM_THREADS];
	Philosopher *all[NUM_THREADS] = {create("Teral", 0 ,1),
					create("Billy", 1, 2),
					create("Daniel", 2,3),
					create("Philip", 3, 4),
					create("Bennet", 0, 4)};
	for (int i = 0; i < NUM_THREADS; i++){
		if (mtx_init(&forks[i], mtx_plain) != thrd_success){
			puts("FAILED IN MUTEX INIT!");
			return 0;
		}
	}
    for (int i=0; i < NUM_THREADS; ++i) {
        if (thrd_create(threadId+i, eat, all[i]) != thrd_success) {
            printf("%d-th thread create error\n", i);
            return 0;
        }
    }

    for (int i=0; i < NUM_THREADS; ++i)
        thrd_join(threadId[i], NULL);
    return 0;
}
