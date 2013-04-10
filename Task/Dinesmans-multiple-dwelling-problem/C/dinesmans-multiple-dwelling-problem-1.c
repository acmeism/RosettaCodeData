#include <stdio.h>
#include <stdlib.h>

int verbose = 0;
#define COND(a, b) int a(int *s) { return (b); }
typedef int(*condition)(int *);

/* BEGIN problem specific setup */
#define N_FLOORS 5
#define TOP (N_FLOORS - 1)
int solution[N_FLOORS] = { 0 };
int occupied[N_FLOORS] = { 0 };

enum tenants {
	baker = 0,
	cooper,
	fletcher,
	miller,
	smith,
	phantom_of_the_opera,
};

const char *names[] = {
	"baker",
	"cooper",
	"fletcher",
	"miller",
	"smith",
};

COND(c0, s[baker] != TOP);
COND(c1, s[cooper] != 0);
COND(c2, s[fletcher] != 0 && s[fletcher] != TOP);
COND(c3, s[miller] > s[cooper]);
COND(c4, abs(s[smith] - s[fletcher]) != 1);
COND(c5, abs(s[cooper] - s[fletcher]) != 1);
#define N_CONDITIONS 6

condition cond[] = { c0, c1, c2, c3, c4, c5 };

/* END of problem specific setup */


int solve(int person)
{
	int i, j;
	if (person == phantom_of_the_opera) {
		/* check condition */
		for (i = 0; i < N_CONDITIONS; i++) {
			if (cond[i](solution)) continue;

			if (verbose) {
				for (j = 0; j < N_FLOORS; j++)
					printf("%d %s\n", solution[j], names[j]);
				printf("cond %d bad\n\n", i);
			}
			return 0;
		}

		printf("Found arrangement:\n");
		for (i = 0; i < N_FLOORS; i++)
			printf("%d %s\n", solution[i], names[i]);
		return 1;
	}

	for (i = 0; i < N_FLOORS; i++) {
		if (occupied[i]) continue;
		solution[person] = i;
		occupied[i] = 1;
		if (solve(person + 1)) return 1;
		occupied[i] = 0;
	}
	return 0;
}

int main()
{
	verbose = 0;
	if (!solve(0)) printf("Nobody lives anywhere\n");
	return 0;
}
