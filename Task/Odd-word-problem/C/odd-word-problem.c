#include <stdio.h>
#include <ctype.h>

int do_char(int odd, void (*f)(void))
{
	int c = getchar();

	void write_out(void) {
		putchar(c);
		if (f) f();
	}

	if (!odd) putchar(c);

	if (isalpha(c))
		return do_char(odd, write_out);

	if (odd) {
		if (f) f();
		putchar(c);
	}

	return c != '.';
}

int main()
{
	int i = 1;
	while (do_char(i = !i, 0));

	return 0;
}
