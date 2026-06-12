#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define DEBUG 0 // set this to 2 for a lot of numbers on output
#define DAYS 365
#define EXCESS (RAND_MAX / DAYS * DAYS)

int days[DAYS];

inline int rand_day(void)
{
	int n;
	while ((n = rand()) >= EXCESS);
	return n / (EXCESS / DAYS);
}

// given p people, if n of them have same birthday in one run
int simulate1(int p, int n)
{
	memset(days, 0, sizeof(days));

	while (p--)
		if (++days[rand_day()] == n) return 1;

	return 0;
}

// decide if the probability of n out of np people sharing a birthday
// is above or below p_thresh, with n_sigmas sigmas confidence
// note that if p_thresh is very low or hi, minimum runs need to be much higher
double prob(int np, int n, double n_sigmas, double p_thresh, double *std_dev)
{
	double p, d; // prob and std dev
	int runs = 0, yes = 0;
	do {
		yes += simulate1(np, n);
		p = (double) yes / ++runs;
		d = sqrt(p * (1 - p) / runs);
		if (DEBUG > 1)
			printf("\t\t%d: %d %d %g %g        \r", np, yes, runs, p, d);
	} while (runs < 10 || fabs(p - p_thresh) < n_sigmas * d);
	if (DEBUG > 1) putchar('\n');

	*std_dev = d;
	return p;
}

// bisect for truth
int find_half_chance(int n, double *p, double *dev)
{
	int lo, hi, mid;

reset:
	lo = 0;
	hi = DAYS * (n - 1) + 1;
	do {
		mid = (hi + lo) / 2;

		// 5 sigma confidence. Conventionally people think 3 sigmas are good
		// enough, but for case of 5 people sharing birthday, 3 sigmas actually
		// sometimes give a slightly wrong answer
		*p = prob(mid, n, 5, .5, dev);

		if (DEBUG)
			printf("\t%d %d %d %g %g\n", lo, mid, hi, *p, *dev);

		if (*p < .5)	lo = mid + 1;
		else		hi = mid;

		if (hi < lo) {
			// this happens when previous precisions were too low;
			// easiest fix: reset
			if (DEBUG) puts("\tMade a mess, will redo.");
			goto reset;
		}
	} while (lo < mid || *p < .5);

	return mid;
}

int main(void)
{
	int n, np;
	double p, d;
	srand(time(0));

	for (n = 2; n <= 5; n++) {
		np = find_half_chance(n, &p, &d);
		printf("%d collision: %d people, P = %g +/- %g\n",
			n, np, p, d);
	}

	return 0;
}
