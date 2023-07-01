typedef unsigned long long int ulong;

ulong mul_mod(ulong a, ulong b, const ulong mod) {
	ulong res = 0, c; // return (a * b) % mod, avoiding overflow errors while doing modular multiplication.
	for (b %= mod; a; a & 1 ? b >= mod - res ? res -= mod : 0, res += b : 0, a >>= 1, (c = b) >= mod - b ? c -= mod : 0, b += c);
	return res % mod;
}

ulong pow_mod(ulong n, ulong exp, const ulong mod) {
	ulong res = 1; // return (n ^ exp) % mod
	for (n %= mod; exp; exp & 1 ? res = mul_mod(res, n, mod) : 0, n = mul_mod(n, n, mod), exp >>= 1);
	return res;
}

int is_prime(ulong N) {
	// Perform a Miller-Rabin test, it should be a deterministic version.
	const ulong n_primes = 9, primes[] = {2, 3, 5, 7, 11, 13, 17, 19, 23};
	for (ulong i = 0; i < n_primes; ++i)
		if (N % primes[i] == 0) return N == primes[i];
	if (N < primes[n_primes - 1]) return 0;
	int res = 1, s = 0;
	ulong t;
	for (t = N - 1; ~t & 1; t >>= 1, ++s);
	for (ulong i = 0; i < n_primes && res; ++i) {
		ulong B = pow_mod(primes[i], t, N);
		if (B != 1) {
			for (int b = s; b-- && (res = B + 1 != N);)
				B = mul_mod(B, B, N);
			res = !res;
		}
	}
	return res;
}

int main(void){
	return is_prime(8193145868754512737);
}
