#include "scriptedmain.h"
#include <stdio.h>

extern int meaning_of_life();

int main(int argc, char **argv) {
	printf("Test: The meaning of life is %d\n", meaning_of_life());
	return 0;
}
