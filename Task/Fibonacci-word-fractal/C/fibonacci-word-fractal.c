#include <stdio.h>

int main(void)
{
	puts(	"%!PS-Adobe-3.0 EPSF\n"
		"%%BoundingBox: -10 -10 400 565\n"
		"/a{0 0 moveto 0 .4 translate 0 0 lineto stroke -1 1 scale}def\n"
		"/b{a 90 rotate}def");

	char i;
	for (i = 'c'; i <= 'z'; i++)
		printf("/%c{%c %c}def\n", i, i-1, i-2);

	puts("0 setlinewidth z showpage\n%%EOF");

	return 0;
}
