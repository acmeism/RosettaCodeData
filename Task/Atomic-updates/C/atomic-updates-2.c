#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

#define irand(n) (n * (double)rand()/(RAND_MAX + 1.0))

int bucket[10];
int main()
{
	int i;
	for (i = 0; i < 10; i++) bucket[i] = 1000;
	omp_set_num_threads(3);

	#pragma omp parallel private(i)
	for (i = 0; i < 10000; i++) {
		int from, to, mode, diff = 0, sum;

		from = irand(10);
		do { to = irand(10); } while (from == to);
		mode = irand(10);

		switch (mode) {
		case 0:
		case 1:
		case 2:	/* equalize */
			diff = (bucket[from] - bucket[to]) / 2;
			break;

		case 3: /* report */
			sum = 0;
			for (int j = 0; j < 10; j++) {
				printf("%d ", bucket[j]);
				sum += bucket[j];
			}
			printf(" Sum: %d\n", sum);
			continue;

		default: /* random transfer */
			diff = irand(bucket[from]);
			break;
		}

		#pragma omp critical
		{
			bucket[from] -= diff;
			bucket[to]   += diff;
		}
	}

	return 0;
}
