#include <stdio.h>

inline int self_desc(unsigned long long xx)
{
	register unsigned int d, x;
	unsigned char cnt[10] = {0}, dig[10] = {0};

	for (d = 0; xx > ~0U; xx /= 10)
		cnt[ dig[d++] = xx % 10 ]++;

	for (x = xx; x; x /= 10)
		cnt[ dig[d++] = x % 10 ]++;

	while(d-- && dig[x++] == cnt[d]);

	return d == -1;
}

int main()
{
	int i;
	for (i = 1; i < 100000000; i++) /* don't handle 0 */
		if (self_desc(i)) printf("%d\n", i);

	return 0;
}
