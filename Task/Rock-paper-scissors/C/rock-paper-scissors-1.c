#include <stdio.h>
#include <stdlib.h>
#define LEN 3

/* pick a random index from 0 to n-1, according to probablities listed
   in p[] which is assumed to have a sum of 1. The values in the probablity
   list matters up to the point where the sum goes over 1 */
int rand_idx(double *p, int n)
{
	double s = rand() / (RAND_MAX + 1.0);
	int i;
	for (i = 0; i < n - 1 && (s -= p[i]) >= 0; i++);
	return i;
}

int main()
{
	int user_action, my_action;
	int user_rec[] = {0, 0, 0};
	const char *names[] = { "Rock", "Paper", "Scissors" };
	char str[2];
	const char *winner[] = { "We tied.", "Meself winned.", "You win." };
	double  p[LEN] = { 1./3, 1./3, 1./3 };

	while (1) {
		my_action = rand_idx(p,LEN);

		printf("\nYour choice [1-3]:\n"
			"  1. Rock\n  2. Paper\n  3. Scissors\n> ");

		/* scanf is a terrible way to do input.  should use stty and keystrokes */
		if (!scanf("%d", &user_action)) {
			scanf("%1s", str);
			if (*str == 'q') {
				printf("Your choices [rock : %d , paper :  %d , scissors %d] ",user_rec[0],user_rec[1], user_rec[2]);
				return 0;
			}
			continue;
		}
		user_action --;
		if (user_action > 2 || user_action < 0) {
			printf("invalid choice; again\n");
			continue;
		}
		printf("You chose %s; I chose %s. %s\n",
			names[user_action], names[my_action],
			winner[(my_action - user_action + 3) % 3]);

		user_rec[user_action]++;
	}
}
