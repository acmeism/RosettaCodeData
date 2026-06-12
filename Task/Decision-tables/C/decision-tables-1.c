#include <stdio.h>

#define N_COND 3
#define COND_LEN (1 << N_COND)

struct { const char *str, *truth;}
cond[N_COND] = {
	{"Printer does not print",		"1111...."},
	{"A red light is flashing",		"11..11.."},
	{"Printer is unrecognised",		"1.1.1.1."},
},
solu[] = {
	{"Check the power cable",		"..1....."},
	{"Check the printer-computer cable",	"1.1....."},
	{"Ensure printer software is installed","1.1.1.1."},
	{"Check/replace ink",			"11..11.."},
	{"Check for paper jam",			".1.1...."},
};

int main()
{
	int q, ans, c;

	for (q = ans = c = 0; q < N_COND; q++) {
		do {
			if (c != '\n') printf("%s? ", cond[q].str);
			c = getchar();
		} while (c != 'y' && c != 'n');
		ans = (ans << 1) | (c != 'y');
	}

	if (ans == COND_LEN - 1)
		printf("\nSo, you don't have a problem then?\n");
	else {
		printf("\nSolutions:\n");
		for (q = 0; q < sizeof(solu)/sizeof(solu[0]); q++)
			if (solu[q].truth[ans] == '1')
				printf("    %s\n", solu[q].str);
	}
	return 0;
}
