#include <stdio.h>

const int next_digit[] = {
		0x7532, 0x8643, 0x97540, 0x86510, 0x97621,
		0x87320, 0x98431, 0x95420, 0x6531, 0x7642
	};

void gen(char *p, int i, const char c)
{
	p[i] = c;

	if (p[i + 1] == '\0')
		puts(p);
	else
		for (int d = next_digit[p[i++] - '0']; d; d >>= 4)
			gen(p, i, '0' + (d&15));
}

int main(void)
{
	// show between 100 and 500
	char buf[4] = {"Hi!"};

	for (char c = '1'; c < '5'; c++)
		gen(buf, 0, c);

	// count 10 digit ones
	unsigned int table[10][10] = {{0}};

	for (int j = 0; j < 10; j++) table[0][j] = 1U;

	for (int i = 1; i < 10; i++)
		for (int j = 0; j < 10; j++)
			for (int d = next_digit[j]; d; d >>= 4)
				table[i][j] += table[i - 1][d&15];

	printf("\n%u 10-digits starting with 1\n", table[9][1]);

	return 0;
}
