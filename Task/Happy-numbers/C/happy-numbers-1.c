#include <stdio.h>

#define CACHE 256
enum { h_unknown = 0, h_yes, h_no };
unsigned char buf[CACHE] = {0, h_yes, 0};

int happy(int n)
{
	int sum = 0, x, nn;
	if (n < CACHE) {
		if (buf[n]) return 2 - buf[n];
		buf[n] = h_no;
	}

	for (nn = n; nn; nn /= 10) x = nn % 10, sum += x * x;

	x = happy(sum);
	if (n < CACHE) buf[n] = 2 - x;
	return x;
}

int main()
{
	int i, cnt = 8;
	for (i = 1; cnt || !printf("\n"); i++)
		if (happy(i)) --cnt, printf("%d ", i);

	printf("The %dth happy number: ", cnt = 1000000);
	for (i = 1; cnt; i++)
		if (happy(i)) --cnt || printf("%d\n", i);

	return 0;
}
