#include <stdio.h>
#include <stdbool.h>
#include <time.h>

#define n 100
#define nn ((n * (n + 1)) >> 1)

bool Contains(int lst[], int item, int size) {
	for (int i = size - 1; i >= 0; i--)
 		if (item == lst[i]) return true;
	return false;
}

int * MianChowla()
{
	static int mc[n]; mc[0] = 1;
	int sums[nn];	sums[0] = 2;
	int sum, le, ss = 1;
	for (int i = 1; i < n; i++) {
		le = ss;
		for (int j = mc[i - 1] + 1; ; j++) {
			mc[i] = j;
			for (int k = 0; k <= i; k++) {
				sum = mc[k] + j;
				if (Contains(sums, sum, ss)) {
					ss = le; goto nxtJ;
				}
				sums[ss++] = sum;
			}
			break;
		nxtJ:;
		}
	}
	return mc;
}

int main() {
	clock_t st = clock(); int * mc; mc = MianChowla();
        double et = ((double)(clock() - st)) / CLOCKS_PER_SEC;
	printf("The first 30 terms of the Mian-Chowla sequence are:\n");
	for (int i = 0; i < 30; i++) printf("%d ", mc[i]);
	printf("\n\nTerms 91 to 100 of the Mian-Chowla sequence are:\n");
	for (int i = 90; i < 100; i++) printf("%d ", mc[i]);
	printf("\n\nComputation time was %f seconds.", et);
}
