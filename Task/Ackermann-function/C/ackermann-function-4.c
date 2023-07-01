/* Thejaka Maldeniya */

#include <conio.h>

unsigned long long HI(unsigned int n, unsigned long long a, unsigned long long b) {
	// Hyperfunction (Iterative): Perform a Hyperoperation...

	unsigned long long *I, r = 1;
	unsigned int N = n - 3;

	if (!N)
		// Exponentiation
		while(b--)
			r *= a;
	else if(b) {
		n -= 2;

		// Allocate
		I = (unsigned long long *) malloc(sizeof(unsigned long long) * n--);

		// Initialize
		I[n] = b;

		// Calculate
		for(;;) {
			if(I[n]) {
				--I[n];
				if (n)
					I[--n] = r, r = 1;
				else
					r *= a;
			} else
				for(;;)
					if (n == N)
						goto a;
					else if(I[++n])
						break;
		}
a:

		// Free
		free(I);
	}

	return r;
}

unsigned long long H(unsigned int n, unsigned long long a, unsigned long long b) {
	// Hyperfunction (Iterative-O(1) Hybrid): Perform a Hyperoperation...

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

	return HI(n, a, b);
}

unsigned long long APH(unsigned int m, unsigned int n) {
	// Ackermann-Péter Function (Recursive-Iterative-O(1) Hybrid)
	return H(m, 2, n + 3) - 3;
}

unsigned long long * p = 0;

unsigned long long APIA(unsigned int m, unsigned int n) {
	if (!m) return ++n;

	// Initialize
	unsigned long long *I, r = p ? p[m] : APIA(m - 1, 1);
	unsigned int M = m;

	if (n) {
		// Allocate
		I = (unsigned long long *) malloc(sizeof(unsigned long long) * (m + 1));

		// Initialize
		I[m] = n;

		// Calculate
		for(;;) {
			if(I[m]) {
				if (m)
					--I[m], I[--m] = r, r = p ? p[m] : APIA(m - 1, 1);
				else
					r += I[m], I[m] = 0;
			} else
				for(;;)
					if (m == M)
						goto a;
					else if(I[++m])
						break;
		}
a:

		// Free
		free(I);
	}

	return r;
}

unsigned long long API(unsigned int m, unsigned int n) {
	unsigned long long r = 0;

	// Allocate
	p = (unsigned long long *) malloc(sizeof(unsigned long long) * (m + 1));

	// Initialize
	for(; r <= m; ++r)
		p[r] = r ? APIA(r - 1, 1) : APIA(r, 0);

	// Calculate
	r = APIA(m, n);

	// Free
	free(p);

	return r;
}

unsigned long long AP(unsigned int m, unsigned int n) {
	return APH(m, n);
	return API(m, n);
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
