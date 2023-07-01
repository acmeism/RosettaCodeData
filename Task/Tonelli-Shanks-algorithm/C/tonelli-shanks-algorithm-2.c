// return (a * b) % mod, avoiding overflow errors while doing modular multiplication.
static unsigned multiplication_modulo(unsigned a, unsigned b, const unsigned mod) {
	unsigned res = 0, tmp;
	for (b %= mod; a; a & 1 ? b >= mod - res ? res -= mod : 0, res += b : 0, a >>= 1, (tmp = b) >= mod - b ? tmp -= mod : 0, b += tmp);
	return res % mod;
}

// return (n ^ exp) % mod
static unsigned mod_pow(unsigned n, unsigned exp, const unsigned mod) {
	unsigned res = 1;
	for (n %= mod; exp; exp & 1 ? res = multiplication_modulo(res, n, mod) : 0, n = multiplication_modulo(n, n, mod), exp >>= 1);
	return res;
}

static unsigned tonelli_shanks_1(const unsigned n, const unsigned mod) {
	// return root such that (root * root) % mod congruent to n % mod.
	// return 0 if no solution to the congruence exists.
	// mod is assumed odd prime.
	const unsigned a = n % mod;
	unsigned res, b, c, d, e, f, g, h;
	if (mod_pow(a, (mod - 1) >> 1, mod) != 1)
		res = 0;
	else
		switch (mod & 7) {
			case 3 : case 7 :
				res = mod_pow(a, (mod + 1) >> 2, mod);
				break;
			case 5 :
				res = mod_pow(a, (mod + 3) >> 3, mod);
				if (multiplication_modulo(res, res, mod) != a){
					b = mod_pow(2, (mod - 1) >> 2, mod);
					res = multiplication_modulo(res, b, mod);
				}
				break;
			default :
				if (a == 1)
					res = 1;
				else {
					for (c = mod - 1, d = 2; d < mod && mod_pow(d, c >> 1, mod) != c; ++d);
					for (e = 0; !(c & 1); ++e, c >>= 1);
					f = mod_pow(a, c, mod);
					b = mod_pow(d, c, mod);
					for (h = 0, g = 0; h < e; h++) {
						d = mod_pow(b, g, mod);
						d = multiplication_modulo(d, f, mod);
						d = mod_pow(d, 1 << (e - 1 - h), mod);
						if (d == mod - 1)
							g += 1 << h;
					}
					f = mod_pow(a, (c + 1) >> 1, mod);
					b = mod_pow(b, g >> 1, mod);
					res = multiplication_modulo(f, b, mod);
				}
		}
	return res;
}

// return root such that (root * root) % mod congruent to n % mod.
// return 0 (the default value of a) if no solution to the congruence exists.
static unsigned tonelli_shanks_2(unsigned n, const unsigned mod) {
	unsigned a = 0, b = mod - 1, c, d = b, e = 0, f = 2, g;
	if (mod_pow(n, b >> 1, mod) == 1) {
		for (; !(d & 1); ++e, d >>= 1);
		if (e == 1)
			a = mod_pow(n, (mod + 1) >> 2, mod);
		else {
			for (; b != mod_pow(f, b >> 1, mod); ++f);
			for (b = mod_pow(f, d, mod), a = mod_pow(n, (d + 1) >> 1, mod), c = mod_pow(n, d, mod), g = e; c != 1; g = d) {
				for (d = 0, e = c, --g; e != 1 && d < g; ++d)
					e = multiplication_modulo(e, e, mod);
				for (f = b, n = g - d; n--;)
					f = multiplication_modulo(f, f, mod);
				a = multiplication_modulo(a, f, mod);
				b = multiplication_modulo(f, f, mod);
				c = multiplication_modulo(c, b, mod);
			}
		}
	}
	return a;
}

#include <assert.h>
int main() {
	unsigned n, mod, root ; /* root_2 = mod - root */

	n = 27875, mod = 26371, root = tonelli_shanks_1(n, mod);
	assert(root == 14320); // 14320 * 14320  mod  26371 = 1504     and   1504 =    27875 mod 26371

	n = 1111111111, mod = 1111111121, root = tonelli_shanks_1(n, mod);
	assert(root == 88664850);

	n = 5258, mod = 3851, root = tonelli_shanks_1(n, mod);
	assert(root == 0); // no solution to the congruence exists.
}
