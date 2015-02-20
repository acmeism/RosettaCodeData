#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <openssl/sha.h>
#include <openssl/ripemd.h>

#define COIN_VER 0
const char *coin_err;

typedef unsigned char byte;

int is_hex(const char *s) {
	int i;
	for (i = 0; i < 64; i++)
		if (!isxdigit(s[i])) return 0;
	return 1;
}

void str_to_byte(const char *src, byte *dst, int n) {
	while (n--) sscanf(src + n * 2, "%2hhx", dst + n);
}

char* base58(byte *s, char *out) {
	static const char *tmpl = "123456789"
		"ABCDEFGHJKLMNPQRSTUVWXYZ"
		"abcdefghijkmnopqrstuvwxyz";
	static char buf[40];

	int c, i, n;
	if (!out) out = buf;

	out[n = 34] = 0;
	while (n--) {
		for (c = i = 0; i < 25; i++) {
			c = c * 256 + s[i];
			s[i] = c / 58;
			c %= 58;
		}
		out[n] = tmpl[c];
	}

	for (n = 0; out[n] == '1'; n++);
	memmove(out, out + n, 34 - n);

	return out;
}

char *coin_encode(const char *x, const char *y, char *out) {
	byte s[65];
	byte rmd[5 + RIPEMD160_DIGEST_LENGTH];

	if (!is_hex(x) || !(is_hex(y))) {
		coin_err = "bad public point string";
		return 0;
	}

	s[0] = 4;
	str_to_byte(x, s + 1, 32);
	str_to_byte(y, s + 33, 32);

	rmd[0] = COIN_VER;
	RIPEMD160(SHA256(s, 65, 0), SHA256_DIGEST_LENGTH, rmd + 1);

	memcpy(rmd + 21, SHA256(SHA256(rmd, 21, 0), SHA256_DIGEST_LENGTH, 0), 4);

	return base58(rmd, out);
}

int main(void) {
	puts(coin_encode(
		"50863AD64A87AE8A2FE83C1AF1A8403CB53F53E486D8511DAD8A04887E5B2352",
		"2CD470243453A299FA9E77237716103ABC11A1DF38855ED6F2EE187E9C582BA6",
		0));
	return 0;
}
