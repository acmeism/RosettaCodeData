#include <stdio.h>
#include <limits.h>

int msb_int(unsigned int x) {
	int ret = sizeof(unsigned int) * CHAR_BIT - 1;
	return x ? ret - __builtin_clz(x) : ret;
}

int msb_long(unsigned long x) {
	int ret = sizeof(unsigned long) * CHAR_BIT - 1;
	return x ? ret - __builtin_clzl(x) : ret;
}

int msb_longlong(unsigned long long x) {
	int ret = sizeof(unsigned long long) * CHAR_BIT - 1;
	return x ? ret - __builtin_clzll(x) : ret;
}

#define lsb_int(x)	(__builtin_ffs(x) - 1)
#define lsb_long(x)	(__builtin_ffsl(x) - 1)
#define lsb_longlong(x) (__builtin_ffsll(x) - 1)

int main()
{
	int i;

        printf("int:\n");
	unsigned int n1;
	for (i = 0, n1 = 1; ; i++, n1 *= 42) {
		printf("42**%d = %10u(x%08x): M %2d L %2d\n",
			i, n1, n1,
			msb_int(n1),
			lsb_int(n1));

		if (n1 >= UINT_MAX / 42) break;
	}

        printf("long:\n");
	unsigned long n2;
	for (i = 0, n2 = 1; ; i++, n2 *= 42) {
		printf("42**%02d = %20lu(x%016lx): M %2d L %2d\n",
			i, n2, n2,
			msb_long(n2),
			lsb_long(n2));

		if (n2 >= ULONG_MAX / 42) break;
	}

	return 0;
}
