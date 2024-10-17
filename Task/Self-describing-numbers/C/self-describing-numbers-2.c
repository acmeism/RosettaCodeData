#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BASE_MIN 2
#define BASE_MAX 94

void selfdesc(unsigned long);

const char *ref = "!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
char *digs;
unsigned long *nums, *inds, inds_sum, inds_val, base;

int main(int argc, char *argv[]) {
int used[BASE_MAX];
unsigned long digs_n, i;
	if (argc != 2) {
		fprintf(stderr, "Usage is %s <digits>\n", argv[0]);
		return EXIT_FAILURE;
	}
	digs = argv[1];
	digs_n = strlen(digs);
	if (digs_n < BASE_MIN || digs_n > BASE_MAX) {
		fprintf(stderr, "Invalid number of digits\n");
		return EXIT_FAILURE;
	}
	for (i = 0; i < BASE_MAX; i++) {
		used[i] = 0;
	}
	for (i = 0; i < digs_n && strchr(ref, digs[i]) && !used[digs[i]-*ref]; i++) {
		used[digs[i]-*ref] = 1;
	}
	if (i < digs_n) {
		fprintf(stderr, "Invalid digits\n");
		return EXIT_FAILURE;
	}
	nums = calloc(digs_n, sizeof(unsigned long));
	if (!nums) {
		fprintf(stderr, "Could not allocate memory for nums\n");
		return EXIT_FAILURE;
	}
	inds = malloc(sizeof(unsigned long)*digs_n);
	if (!inds) {
		fprintf(stderr, "Could not allocate memory for inds\n");
		free(nums);
		return EXIT_FAILURE;
	}
	inds_sum = 0;
	inds_val = 0;
	for (base = BASE_MIN; base <= digs_n; base++) {
		selfdesc(base);
	}
	free(inds);
	free(nums);
	return EXIT_SUCCESS;
}

void selfdesc(unsigned long i) {
unsigned long diff_sum, upper_min, j, lower, upper, k;
	if (i) {
		diff_sum = base-inds_sum;
		upper_min = inds_sum ? diff_sum:base-1;
		j = i-1;
		if (j) {
			lower = 0;
			upper = (base-inds_val)/j;
		}
		else {
			lower = diff_sum;
			upper = diff_sum;
		}
		if (upper < upper_min) {
			upper_min = upper;
		}
		for (inds[j] = lower; inds[j] <= upper_min; inds[j]++) {
			nums[inds[j]]++;
			inds_sum += inds[j];
			inds_val += inds[j]*j;
			for (k = base-1; k > j && nums[k] <= inds[k] && inds[k]-nums[k] <= i; k--);
			if (k == j) {
				selfdesc(i-1);
			}
			inds_val -= inds[j]*j;
			inds_sum -= inds[j];
			nums[inds[j]]--;
		}
	}
	else {
		for (j = 0; j < base; j++) {
			putchar(digs[inds[j]]);
		}
		puts("");
	}
}
