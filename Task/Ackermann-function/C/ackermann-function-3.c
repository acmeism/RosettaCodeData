/* Thejaka Maldeniya */

#include <conio.h>

unsigned long long HR(unsigned int n, unsigned long long a, unsigned long long b) {
	// (Internal) Recursive Hyperfunction: Perform a Hyperoperation...

	unsigned long long r = 1;

	while(b--)
		r = n - 3 ? HR(n - 1, a, r) : /* Exponentiation */ r * a;

	return r;
}

unsigned long long H(unsigned int n, unsigned long long a, unsigned long long b) {
	// Hyperfunction (Recursive-Iterative-O(1) Hybrid): Perform a Hyperoperation...

	switch(n) {
		case 0:
			// Increment
			return ++b;
		case 1:
			// Addition
			return a + b;
		case 2:
			// Multiplication
			return a * b;
	}

	return HR(n, a, b);
}

unsigned long long APH(unsigned int m, unsigned int n) {
	// Ackermann-Péter Function (Recursive-Iterative-O(1) Hybrid)
	return H(m, 2, n + 3) - 3;
}

unsigned long long * p = 0;

unsigned long long APRR(unsigned int m, unsigned int n) {
	if (!m) return ++n;

	unsigned long long r = p ? p[m] : APRR(m - 1, 1);

	--m;
	while(n--)
		r = APRR(m, r);

	return r;
}

unsigned long long APRA(unsigned int m, unsigned int n) {
	return
		m ?
			n ?
				APRR(m, n)
				: p ? p[m] : APRA(--m, 1)
			: ++n
		;
}

unsigned long long APR(unsigned int m, unsigned int n) {
	unsigned long long r = 0;

	// Allocate
	p = (unsigned long long *) malloc(sizeof(unsigned long long) * (m + 1));

	// Initialize
	for(; r <= m; ++r)
		p[r] = r ? APRA(r - 1, 1) : APRA(r, 0);

	// Calculate
	r = APRA(m, n);

	// Free
	free(p);

	return r;
}

unsigned long long AP(unsigned int m, unsigned int n) {
	return APH(m, n);
	return APR(m, n);
}

int main(int n, char ** a) {
	unsigned int M, N;

	if (n != 3) {
		printf("Usage: %s <m> <n>\n", *a);
		return 1;
	}

	printf("AckermannPeter(%u, %u) = %llu\n", M = atoi(a[1]), N = atoi(a[2]), AP(M, N));

	//printf("\nPress any key...");
	//getch();
	return 0;
}
