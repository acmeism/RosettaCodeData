#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

bool ispalindromic(int n) {
    int i, j;
	char s[20];
	itoa(n, s, 10);
	i = 0;
	j = strlen(s) - 1;
	while (i < j) {
		if (s[i] != s[j]) return false;
		i++;
		j--;
	}
	return true;
}

bool isprime(int n) {
	int i;
	if (n < 2) return false;
	if (n % 2 == 0) return (n == 2);
	for (i = 3; i * i <= n; i += 2) {
		if (n % i == 0) return false;
	}
	return true;
}

int main(void) {
	int i, count;
	count = 0;
	for (i = 2; i <= 1000; i++) {
		if (isprime(i) && ispalindromic(i)) {
			printf("%d ", i);
			count++;
		}
	}
	printf("\nFound %d palindromic primes\n", count);
	return EXIT_SUCCESS;
}
