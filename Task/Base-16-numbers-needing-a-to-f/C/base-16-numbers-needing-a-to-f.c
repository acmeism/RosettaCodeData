#include <stdio.h>

int main(void)
{
	unsigned int h, l, n;

	for (h = 0; h != 512; h += 16) {
		for (l = (h & 0xff) < 0xa0 ? 10 : 0; l != 16; ++l) {
			n = h | l;
			if (n > 500) {
				puts("");
				return 0;
			}
			printf(" %u", n);
		}
	}

	return 0;
}
