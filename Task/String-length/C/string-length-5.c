#include <stdio.h>
#include <stdlib.h>
#include <locale.h>

int main()
{
	setlocale(LC_CTYPE, "");
	char moose[] = "møøse";
	printf("bytes: %d\n", sizeof(moose) - 1);
	printf("chars: %d\n", (int)mbstowcs(0, moose, 0));

	return 0;
}
