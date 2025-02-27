#include <stdio.h>

int
totient(int n)
{
	int result = n;
	
	for (int i=2; i*i <= n; i+=2) {
		if (n % i == 0) {
			while (n % i == 0)
				n /= i;
			result -= result / i;
		}
		
		if (i == 2)
			i = 1;
	}
	
	if (n > 1)
		result -= result / n;
	return result;
}

int
main(void)
{
	int count, n, tot;
	
	printf(" n  phi  prime\n");
    printf("--------------\n");

	count = 0;
	for (n = 1; n <= 25; n++) {
		tot = totient(n);
		
		if (tot == n - 1)
			count++;
		
		printf("%2d   %2d   %s\n", n, tot, tot == (n-1) ? "true" : "false");
	}

	printf("\n");

	for (n = 26; n <= 100000; n++) {
        tot = totient(n);
        if (tot == n-1)
			count++;

        if (n == 100 || n == 1000 || n == 10000) {
            printf("\nNumber of primes up to %6d = %4d\n", n, count);
        }
    }
	
	return 0;
}
