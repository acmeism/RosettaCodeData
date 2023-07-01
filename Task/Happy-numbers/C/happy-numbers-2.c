#include <stdio.h>

int dsum(int n)
{
	int sum, x;
	for (sum = 0; n; n /= 10) x = n % 10, sum += x * x;
	return sum;
}

int happy(int n)
{
	int nn;
	while (n > 999) n = dsum(n); /* 4 digit numbers can't cycle */
	nn = dsum(n);
	while (nn != n && nn != 1)
		n = dsum(n), nn = dsum(dsum(nn));
	return n == 1;
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
