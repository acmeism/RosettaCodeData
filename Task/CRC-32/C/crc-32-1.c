#include <stdio.h>
#include <string.h>
#include <zlib.h>

int main()
{
	const char *s = "The quick brown fox jumps over the lazy dog";
	printf("%lX\n", crc32(0, (const void*)s, strlen(s)));

	return 0;
}
