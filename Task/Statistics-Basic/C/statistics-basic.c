#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdint.h>

#define n_bins 10

double rand01() { return rand() / (RAND_MAX + 1.0); }

double avg(int count, double *stddev, int *hist)
{
	double x[count];
	double m = 0, s = 0;

	for (int i = 0; i < n_bins; i++) hist[i] = 0;
	for (int i = 0; i < count; i++) {
		m += (x[i] = rand01());
		hist[(int)(x[i] * n_bins)] ++;
	}

	m /= count;
	for (int i = 0; i < count; i++)
		s += x[i] * x[i];
	*stddev = sqrt(s / count - m * m);
	return m;
}

void hist_plot(int *hist)
{
	int max = 0, step = 1;
	double inc = 1.0 / n_bins;

	for (int i = 0; i < n_bins; i++)
		if (hist[i] > max) max = hist[i];

	/* scale if numbers are too big */
	if (max >= 60) step = (max + 59) / 60;

	for (int i = 0; i < n_bins; i++) {
		printf("[%5.2g,%5.2g]%5d ", i * inc, (i + 1) * inc, hist[i]);
		for (int j = 0; j < hist[i]; j += step)
			printf("#");
		printf("\n");
	}
}

/*  record for moving average and stddev.  Values kept are sums and sum data^2
 *  to avoid excessive precision loss due to divisions, but some loss is inevitable
 */
typedef struct {
	uint64_t size;
	double sum, x2;
	uint64_t hist[n_bins];
} moving_rec;

void moving_avg(moving_rec *rec, double *data, int count)
{
	double sum = 0, x2 = 0;
	/* not adding data directly to the sum in case both recorded sum and
	 * count of this batch are large; slightly less likely to lose precision*/
	for (int i = 0; i < count; i++) {
		sum += data[i];
		x2 += data[i] * data[i];
		rec->hist[(int)(data[i] * n_bins)]++;
	}

	rec->sum += sum;
	rec->x2 += x2;
	rec->size += count;
}

int main()
{
	double m, stddev;
	int hist[n_bins], samples = 10;

	while (samples <= 10000) {
		m = avg(samples, &stddev, hist);
		printf("size %5d: %g %g\n", samples, m, stddev);
		samples *= 10;
	}

	printf("\nHistograph:\n");
	hist_plot(hist);

	printf("\nMoving average:\n  N     Mean    Sigma\n");
	moving_rec rec = { 0, 0, 0, {0} };
	double data[100];
	for (int i = 0; i < 10000; i++) {
		for (int j = 0; j < 100; j++) data[j] = rand01();

		moving_avg(&rec, data, 100);

		if ((i % 1000) == 999) {
			printf("%4lluk %f %f\n",
				rec.size/1000,
				rec.sum / rec.size,
				sqrt(rec.x2 * rec.size - rec.sum * rec.sum)/rec.size
			);
		}
	}
}
