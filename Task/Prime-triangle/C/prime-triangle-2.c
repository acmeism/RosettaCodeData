#include <stdio.h>
#include <stdint.h>

#define GCC_ASM // use GCC's asm for i386. If it does not work, #undef it to use alternative func
typedef uint32_t uint;
typedef uint64_t ulong;

#define MASK 0xa08228828228a2bULL

#ifdef GCC_ASM

static inline uint
bpos(uint x)
{
	uint b;
	asm("bsf %0, %0" : "=r" (b): "0" (x));
	return b;
}

#else

static inline uint
bpos(uint x)
{
	static const uint bruijin[32] = {
		 0,  1, 28,  2, 29, 14, 24, 3, 30, 22, 20, 15, 25, 17,  4, 8,
		31, 27, 13, 23, 21, 19, 16, 7, 26, 12, 18,  6, 11,  5, 10, 9
	};
	return bruijin[((uint)((x & -x) * 0x077CB531U)) >> 27];
}

#endif // GCC_ASM

int count(uint n, const uint s, uint avail)
{
	int cnt = 0;

	avail ^= s;
	if (--n)
		for (uint b = (uint)(MASK>>bpos(s)) & avail; b; b &= b-1)
			cnt += count(n, b&-b, avail);
	else
		return (MASK & s) != 0;

	return cnt;
}

int disp(uint n, const uint s, uint avail, int maxn, uint *seq)
{
	seq[n--] = s;
	if (!n) {
		if ((MASK & s)) {
			for (int i = 0; i < maxn; i++)
				printf(" %d", bpos(seq[i]) + 1);
			putchar('\n');
			return 1;
		}
	} else {
		for (uint b = (uint)(MASK>>bpos(s)) & (avail ^= s); b; b &= b-1)
			if (disp(n, b&-b, avail, maxn, seq))
				return 1;
	}
	return 0;
}

int chain(uint n, int count_only)
{
	const uint top = 1U<<(n - 1);
	const uint avail = 2*top - 2;

	if (count_only)
		return count(n - 1, top, avail);

	uint seq[32];
	seq[0] = 1;
	disp(n - 1, top, avail, n, seq);

	return 0;
}

int main(void)
{
	for (int n = 2; n < 21; n++)
		chain(n, 0);
	putchar('\n');

	for (int n = 2; n < 21; n++)
		printf("%d ", chain(n, 1));
	putchar('\n');

	return 0;
}
