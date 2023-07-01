typedef unsigned long long int ulong; // define a type that represent the limit (64-bit)

ulong mod_mul(ulong a, ulong b, const ulong mod) {
	ulong res = 0, c; // return (a * b) % mod, avoiding overflow errors while doing modular multiplication.
	for (b %= mod; a; a & 1 ? b >= mod - res ? res -= mod : 0, res += b : 0, a >>= 1, (c = b) >= mod - b ? c -= mod : 0, b += c);
	return res % mod;
}

ulong mod_pow(ulong n, ulong exp, const ulong mod) {
	ulong res = 1; // return (n ^ exp) % mod
	for (n %= mod; exp; exp & 1 ? res = mod_mul(res, n, mod) : 0, n = mod_mul(n, n, mod), exp >>= 1);
	return res;
}

ulong square_root(const ulong N) {
	ulong res = 0, rem = N, c, d;
	for (c = 1 << 62; c; c >>= 2) {
		d = res + c;
		res >>= 1;
		if (rem >= d)
			rem -= d, res += c;
	} // returns the square root of N.
	return res;
}

int is_prime(const ulong N) {
	ulong i = 1; // return a truthy value about the primality of N.
	if (N > 1) for (; i < 64 && mod_pow(i, N - 1, N) <= 1; ++i);
	return i == 64;
}

ulong pollard_rho(const ulong N) {
	// Require : N is a composite number, not a square.
	// Ensure : res is a non-trivial factor of N.
	// Option : change the timeout, change the rand function.
	static const int timeout = 18;
	static unsigned long long rand_val = 2994439072U;
	rand_val = (rand_val * 1025416097U + 286824428U) % 4294967291LLU;
	ulong res = 1, a, b, c, i = 0, j = 1, x = 1, y = 1 + rand_val % (N - 1);
	for (; res == 1; ++i) {
		if (i == j) {
			if (j >> timeout)
				break;
			j <<= 1;
			x = y;
		}
		a = y, b = y; // performs y = (y * y) % N
		for (y = 0; a; a & 1 ? b >= N - y ? y -= N : 0, y += b : 0, a >>= 1, (c = b) >= N - b ? c -= N : 0, b += c);
		y = (1 + y) % N;
		for (a = y > x ? y - x : x - y, b = N; (a %= b) && (b %= a);); // compute the gcd(abs(y - x), N);
		res = a | b;
	}
	return res;
}

void factor(const ulong N, ulong *array) {
	// very basic manager that fill the given array (the size of the result is the first array element)	
	// it does not perform initial trial divisions, which is generally highly recommended.
	if (N < 4 || is_prime(N)) {
		if (N > 1 || !*array) array[++*array] = N;
		return;
	}
	ulong x = square_root(N);
	if (x * x != N) x = pollard_rho(N);
	factor(x, array);
	factor(N / x, array);
}

#include <stdio.h>

int main(void) {
	// simple test.
	unsigned long long n = 18446744073709551615U;
	ulong fac[65] = {0};
	factor(n, fac);
	for (ulong i = 1; i <= *fac; ++i)
		printf("* %llu\n", fac[i]);
}
