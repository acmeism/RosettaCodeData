#include <stdio.h>

// calculates if everyone got some nuts in the end, what was the original pile
// returns 0 if impossible
int total(int n, int nuts)
{
	int k;
	for (k = 0, nuts *= n; k < n; k++) {
		if (nuts % (n-1)) return 0;
		nuts += nuts / (n-1) + 1;
	}
	return nuts;
}

int main(void)
{
	int n, x, t;
	for (n = 2; n < 10; n++) {
		for (x = 1, t = 0; !(t = total(n, x)); x++);
		printf("%d: %d\t%d\n", n, t, x);
	}
	return 0;
}
