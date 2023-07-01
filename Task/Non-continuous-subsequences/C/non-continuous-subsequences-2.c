#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

void binprint(unsigned int n, unsigned int m)
{
	char c[sizeof(n) * 8 + 1];
	int i = 0;
	while (m >>= 1)	c[i++] = n & m ? '#' : '-';
	c[i] = 0;
	puts(c);
}

int main(int c, char **v)
{
	unsigned int n, gap, left, right;
	if (c < 2 || ! (n = 1 << atoi(v[1]))) n = 16;

	for (gap = 2; gap < n; gap <<= 1)
		for (left = gap << 1; left < n; left |= left << 1)
			for (right = 1; right < gap; right++)
				binprint(left | right, n);

	return 0;
}
