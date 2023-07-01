#include <stdio.h>

char trans[] = "___#_##_";

int evolve(char c[], int len)
{
	int i, diff = 0;
#	define v(i) ((c[i] & 15) == 1)
#	define each for (i = 0; i < len; i++)

	each c[i]  = (c[i] == '#');
	each c[i] |= (trans[(v(i-1)*4 + v(i)*2 + v(i+1))] == '#') << 4;
	each diff += (c[i] & 0xf) ^ (c[i] >> 4);
	each c[i]  = (c[i] >> 4) ? '#' : '_';

#	undef each
#	undef v
	return diff;
}

int main()
{
	char c[] = "_###_##_#_#_#_#__#__\n";

	do { printf(c + 1); } while (evolve(c + 1, sizeof(c) - 3));
	return 0;
}
