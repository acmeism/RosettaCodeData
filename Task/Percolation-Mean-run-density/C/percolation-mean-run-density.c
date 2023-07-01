#include <stdio.h>
#include <stdlib.h>

// just generate 0s and 1s without storing them
double run_test(double p, int len, int runs)
{
	int r, x, y, i, cnt = 0, thresh = p * RAND_MAX;

	for (r = 0; r < runs; r++)
		for (x = 0, i = len; i--; x = y)
			cnt += x < (y = rand() < thresh);

	return (double)cnt / runs / len;
}

int main(void)
{
	double p, p1p, K;
	int ip, n;

	puts(	"running 1000 tests each:\n"
		" p\t   n\tK\tp(1-p)\t     diff\n"
		"-----------------------------------------------");
	for (ip = 1; ip < 10; ip += 2) {
		p = ip / 10., p1p = p * (1 - p);

		for (n = 100; n <= 100000; n *= 10) {
			K = run_test(p, n, 1000);
			printf("%.1f\t%6d\t%.4f\t%.4f\t%+.4f (%+.2f%%)\n",
				p, n, K, p1p, K - p1p, (K - p1p) / p1p * 100);
		}
		putchar('\n');
	}

	return 0;
}
