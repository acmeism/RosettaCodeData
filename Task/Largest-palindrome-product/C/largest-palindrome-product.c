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
	while (j > i) {
		if (s[i] != s[j]) return false;
		i++;
		j--;
	}
	return true;
}

int main(void) {
	int i, j, product, largest, m1, m2;
	largest = 1;
	for (i = 100; i <= 999; i++)
	    for (j = i; j <= 999; j++) {
			product = i * j;
	        if (ispalindromic(product) && product >= largest) {
	        	largest = product;
                m1 = i;
                m2 = j;
			}
	    }
	printf("The largest palindromic product of 3-digit numbers is %d (%d * %d)\n", largest, m1, m2);
	return EXIT_SUCCESS;
}
